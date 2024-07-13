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
        private Game game;
        private string screenName;
        private Rectangle frame;
        private Label gameStateText;
        private System.Windows.Forms.Timer timer;
        private DateTime lastUpdateTime;
        private List<RenderedItem> renderedItems;

        private bool isMouseDown;
        private PointF mouseDownPosition;
        private PointF dragDelta;
        private uint targetId;

        public GameForm(double uiFps, Game game, bool debugEnabled)
        {
            this.uiFps = uiFps;
            this.debugEnabled = debugEnabled;
            this.game = game;
            screenName = game.ScreenName;
            frame = new Rectangle((int)game.Bounds.X, (int)game.Bounds.Y, (int)game.Bounds.W, (int)game.Bounds.H);
            lastUpdateTime = DateTime.Now;
            DoubleBuffered = true;
            renderedItems = new List<RenderedItem>();

            InitializeComponents();
            SetupTimer();

            MouseDown += GameForm_MouseDown;
            MouseMove += GameForm_MouseMove;
            MouseUp += GameForm_MouseUp;
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
            Text = "Game Window";
            FormBorderStyle = FormBorderStyle.None;
            TopMost = true;
            AllowTransparency = true;
            BackColor = Color.Magenta;
            TransparencyKey = Color.Magenta;
            Size = new Size(frame.Width, frame.Height);
            StartPosition = FormStartPosition.Manual;
            Location = new Point(frame.X, frame.Y);

            gameStateText = new Label();
            gameStateText.ForeColor = Color.Yellow;
            gameStateText.Font = new Font("Courier New", 15, FontStyle.Regular);
            gameStateText.Location = new Point(10, 30);
            gameStateText.AutoSize = true;
            gameStateText.BackColor = Color.Transparent;
            Controls.Add(gameStateText);
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

            foreach (RenderedItem item in renderedItems)
            {
                DrawItem(g, item);
            }
        }

        private void DrawItem(Graphics g, RenderedItem item)
        {
            if (string.IsNullOrEmpty(item.SpritePath)) { return; }

            Image image = Image.FromFile(item.SpritePath);
            if (item.IsFlipped)
            {
                image.RotateFlip(RotateFlipType.RotateNoneFlipX);
            }
            if (item.ZRotation != 0)
            {
                image = RotateImage(image, item.ZRotation);
            }

            Bitmap borderedImage = new Bitmap((int)item.Frame.W, (int)item.Frame.H);
            using (Graphics bg = Graphics.FromImage(borderedImage))
            {
                bg.Clear(Color.Transparent);
                bg.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.NearestNeighbor;
                bg.DrawImage(image, new Rectangle(0, 0, (int)item.Frame.W, (int)item.Frame.H));
            }

            g.DrawImage(borderedImage, new Rectangle(
                (int)(frame.X + item.Frame.X + (targetId == item.Id ? dragDelta.X : 0)),
                (int)(frame.Y + item.Frame.Y + (targetId == item.Id ? dragDelta.Y : 0)),
                (int)item.Frame.W,
                (int)item.Frame.H
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
                    frame.X + (float)item.Frame.X,
                    frame.Y + (float)item.Frame.Y,
                    (float)item.Frame.W,
                    (float)item.Frame.H
                );
                if (itemRect.Contains(position))
                {
                    return item.Id;
                }
            }
            return 0;
        }
    }
}
