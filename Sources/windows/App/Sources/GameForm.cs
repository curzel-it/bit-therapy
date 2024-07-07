using BitTherapyCLR;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Windows.Forms;

namespace App
{
    public class GameForm : Form
    {
        private double uiFps;
        private bool debugEnabled;
        private ManagedGame game;
        private string screenName;
        private Rectangle frame;
        private Label gameStateText;
        private System.Windows.Forms.Timer timer;
        private DateTime lastUpdateTime;
        private List<MRenderedItem> renderedItems;

        private bool isMouseDown;
        private PointF mouseDownPosition;
        private PointF dragDelta;
        private uint targetId;

        public GameForm(double uiFps, ManagedGame game, bool debugEnabled)
        {
            this.uiFps = uiFps;
            this.debugEnabled = debugEnabled;
            this.game = game;
            this.screenName = game.ScreenName();
            this.frame = new Rectangle((int)game.x, (int)game.y, (int)game.w, (int)game.h);
            this.lastUpdateTime = DateTime.Now;
            this.DoubleBuffered = true;
            this.renderedItems = new List<MRenderedItem>();

            InitializeComponents();
            SetupTimer();

            this.MouseDown += GameForm_MouseDown;
            this.MouseMove += GameForm_MouseMove;
            this.MouseUp += GameForm_MouseUp;
        }

        private void SetupTimer()
        {
            timer = new System.Windows.Forms.Timer();
            timer.Interval = (int)(1000 / uiFps);
            timer.Tick += Update;
            timer.Start();
        }

        private void InitializeComponents()
        {
            this.Text = "Game Window";
            this.FormBorderStyle = FormBorderStyle.None;
            this.TopMost = true;
            this.AllowTransparency = true;
            this.BackColor = Color.Magenta;
            this.TransparencyKey = Color.Magenta;
            this.Size = new Size(frame.Width, frame.Height);
            this.StartPosition = FormStartPosition.Manual;
            this.Location = new Point(frame.X, frame.Y);

            gameStateText = new Label();
            gameStateText.ForeColor = Color.Yellow;
            gameStateText.Font = new Font("Courier New", 15, FontStyle.Regular);
            gameStateText.Location = new Point(10, 30);
            gameStateText.AutoSize = true;
            gameStateText.BackColor = Color.Transparent;
            this.Controls.Add(gameStateText);
        }

        private void Update(object? sender, EventArgs e)
        {
            DateTime now = DateTime.Now;
            TimeSpan timeSinceLastUpdate = now - lastUpdateTime;
            lastUpdateTime = now;

            game.Update(timeSinceLastUpdate);

            renderedItems = game.Render();

            if (debugEnabled)
            {
                gameStateText.Text = game.Description();
            }

            Invalidate();
        }

        protected override void OnPaint(PaintEventArgs e)
        {
            base.OnPaint(e);
            Graphics g = e.Graphics;
            g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.NearestNeighbor;

            foreach (MRenderedItem item in renderedItems)
            {
                DrawItem(g, item);
            }
        }

        private void DrawItem(Graphics g, MRenderedItem item)
        {
            if (string.IsNullOrEmpty(item.spritePath)) { return; }

            Image image = Image.FromFile(item.spritePath);
            if (item.isFlipped)
            {
                image.RotateFlip(RotateFlipType.RotateNoneFlipX);
            }
            if (item.zRotation != 0)
            {
                image = RotateImage(image, item.zRotation);
            }

            Bitmap borderedImage = new Bitmap((int)item.w, (int)item.h);
            using (Graphics bg = Graphics.FromImage(borderedImage))
            {
                bg.Clear(Color.Transparent);
                bg.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.NearestNeighbor;
                bg.DrawImage(image, new Rectangle(0, 0, (int)item.w, (int)item.h));
            }

            g.DrawImage(borderedImage, new Rectangle(
                (int)(frame.X + item.x + (targetId == item.id ? dragDelta.X : 0)),
                (int)(frame.Y + item.y + (targetId == item.id ? dragDelta.Y : 0)),
                (int)item.w,
                (int)item.h
            ));
        }

        private Image RotateImage(Image img, double rotationAngle)
        {
            Bitmap bmp = new Bitmap(img.Width, img.Height);
            using (Graphics g = Graphics.FromImage(bmp))
            {
                g.TranslateTransform((float)bmp.Width / 2, (float)bmp.Height / 2);
                g.RotateTransform((float)rotationAngle);
                g.TranslateTransform(-(float)bmp.Width / 2, -(float)bmp.Height / 2);
                g.DrawImage(img, new Point(0, 0));
            }
            return bmp;
        }

        private void GameForm_MouseDown(object sender, MouseEventArgs e)
        {
            isMouseDown = true;
            mouseDownPosition = e.Location;
            targetId = GetTargetIdAtPosition(e.Location);
            if (targetId != 0)
            {
                game.MouseDragStarted(targetId);
            }
        }

        private void GameForm_MouseMove(object sender, MouseEventArgs e)
        {
            if (isMouseDown && targetId != 0)
            {
                dragDelta.X = e.X - mouseDownPosition.X;
                dragDelta.Y = e.Y - mouseDownPosition.Y;
            }
        }

        private void GameForm_MouseUp(object sender, MouseEventArgs e)
        {
            if (isMouseDown && targetId != 0)
            {
                game.MouseDragEnded(targetId, dragDelta.X, dragDelta.Y);
                isMouseDown = false;
                dragDelta = new PointF(0, 0);
                targetId = 0;
            }
        }

        private uint GetTargetIdAtPosition(PointF position)
        {
            foreach (var item in renderedItems)
            {
                var itemRect = new RectangleF(
                    frame.X + (float)item.x, 
                    frame.Y + (float)item.y,
                    (float)item.w,
                    (float)item.h
                );
                if (itemRect.Contains(position))
                {
                    return item.id;
                }
            }
            return 0;
        }
    }
}
