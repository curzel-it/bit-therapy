using System;
using System.Drawing;
using System.Windows.Forms;
using System.Collections.Generic;
using App;

namespace App
{
    public class AvailableSpeciesForm : Form
    {
        private SpeciesRepository speciesRepo;
        private SpritesRepository spritesRepo;
        private FlowLayoutPanel selectedPanel;
        private FlowLayoutPanel nonSelectedPanel;

        public AvailableSpeciesForm(SpeciesRepository speciesRepo, SpritesRepository spritesRepo)
        {
            this.spritesRepo = spritesRepo;
            this.speciesRepo = speciesRepo;
            InitializeForm();
        }

        private void InitializeForm()
        {
            Text = "BitTherapy for Windows BETA";
            Size = new Size(800, 600);
            AutoScroll = true;

            FlowLayoutPanel mainPanel = new FlowLayoutPanel();
            mainPanel.Dock = DockStyle.Fill;
            mainPanel.AutoScroll = true;
            mainPanel.FlowDirection = FlowDirection.TopDown;
            mainPanel.WrapContents = false;
            Controls.Add(mainPanel);

            Label selectedLabel = new Label();
            selectedLabel.Text = "Selected Species";
            selectedLabel.Font = new Font(selectedLabel.Font, FontStyle.Bold);
            mainPanel.Controls.Add(selectedLabel);

            selectedPanel = new FlowLayoutPanel();
            selectedPanel.AutoSize = true;
            selectedPanel.WrapContents = true;
            selectedPanel.FlowDirection = FlowDirection.LeftToRight;
            mainPanel.Controls.Add(selectedPanel);

            Label nonSelectedLabel = new Label();
            nonSelectedLabel.Text = "Non-Selected Species";
            nonSelectedLabel.Font = new Font(nonSelectedLabel.Font, FontStyle.Bold);
            mainPanel.Controls.Add(nonSelectedLabel);

            nonSelectedPanel = new FlowLayoutPanel();
            nonSelectedPanel.AutoSize = true;
            nonSelectedPanel.WrapContents = true;
            nonSelectedPanel.FlowDirection = FlowDirection.LeftToRight;
            mainPanel.Controls.Add(nonSelectedPanel);

            LoadSpeciesPanels();
        }

        private void LoadSpeciesPanels()
        {
            List<string> selectedSpeciesIds = AppConfigRepository.GetSelectedSpecies();
            List<String> speciesList = speciesRepo.AvailableSpecies();

            foreach (var speciesId in speciesList)
            {
                var species = speciesRepo.GetSpecies(speciesId);
                var spritePath = spritesRepo.GetSprites(speciesId).SpriteFrames("front").FirstOrDefault();
                if (species != null && spritePath != null) {
                    FlowLayoutPanel targetPanel = selectedSpeciesIds.Contains(speciesId) ? selectedPanel : nonSelectedPanel;
                    AddSpeciesToPanel(species, spritePath, targetPanel);
                }
            }
        }

        private void AddSpeciesToPanel(Species species, String spritePath, FlowLayoutPanel panel)
        {
            PictureBox pictureBox = new PictureBox();
            pictureBox.Size = new Size(75, 75);

            Bitmap speciesBitmap = new Bitmap(spritePath);
            pictureBox.Image = ResizeImage(speciesBitmap, pictureBox.Size.Width, pictureBox.Size.Height);

            Panel speciesPanel = new Panel();
            speciesPanel.Size = new Size(pictureBox.Size.Width + 10, pictureBox.Size.Height + 20);
            speciesPanel.Controls.Add(pictureBox);
            speciesPanel.Tag = species;

            pictureBox.Click += (sender, e) =>
            {
                if (panel == nonSelectedPanel)
                {
                    MoveSpecies(speciesPanel, selectedPanel);
                }
                else
                {
                    MoveSpecies(speciesPanel, nonSelectedPanel);
                }
                SaveSelectedSpecies();
            };

            panel.Controls.Add(speciesPanel);
        }

        private void MoveSpecies(Panel speciesPanel, FlowLayoutPanel targetPanel)
        {
            FlowLayoutPanel currentPanel = (FlowLayoutPanel)speciesPanel.Parent;
            currentPanel.Controls.Remove(speciesPanel);
            targetPanel.Controls.Add(speciesPanel);
        }

        private void SaveSelectedSpecies()
        {
            List<string> selectedSpeciesIds = new List<string>();

            foreach (Panel panel in selectedPanel.Controls)
            {
                Species species = (Species)panel.Tag;
                selectedSpeciesIds.Add(species.Id);
            }

            AppConfigRepository.SaveSelectedSpecies(selectedSpeciesIds);

            // Reload the GameForms
            Program.ReloadGameForms();
        }

        private Bitmap ResizeImage(Bitmap image, int width, int height)
        {
            Bitmap resizedImage = new Bitmap(width, height);
            using (Graphics graphics = Graphics.FromImage(resizedImage))
            {
                graphics.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.NearestNeighbor;
                graphics.DrawImage(image, new Rectangle(0, 0, width, height));
            }
            return resizedImage;
        }
    }
}
