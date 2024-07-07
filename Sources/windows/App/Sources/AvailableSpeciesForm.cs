using System;
using System.Drawing;
using System.Windows.Forms;
using BitTherapyCLR;
using System.Collections.Generic;
using App;

namespace BitTherapyWinForms
{
    public class AvailableSpeciesForm : Form
    {
        private ManagedGame managedGame;
        private FlowLayoutPanel selectedPanel;
        private FlowLayoutPanel nonSelectedPanel;

        public AvailableSpeciesForm(List<String> speciesPaths, List<String> assetsPaths)
        {
            InitializeManagedGame(speciesPaths, assetsPaths);
            InitializeForm();
        }

        private void InitializeManagedGame(List<String> speciesPaths, List<String> assetsPaths)
        {
            managedGame = new ManagedGame(
                "SpeciesGrid",
                0, 0, 1, 1, 1, 1, 1, 1,
                speciesPaths,
                assetsPaths
            );
        }

        private void InitializeForm()
        {
            this.Text = "BitTherapy for Windows BETA";
            this.Size = new Size(800, 600);
            this.AutoScroll = true;

            FlowLayoutPanel mainPanel = new FlowLayoutPanel();
            mainPanel.Dock = DockStyle.Fill;
            mainPanel.AutoScroll = true;
            mainPanel.FlowDirection = FlowDirection.TopDown;
            mainPanel.WrapContents = false;
            this.Controls.Add(mainPanel);

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
            List<ManagedSpecies> speciesList = managedGame.AvailableSpecies();

            foreach (ManagedSpecies species in speciesList)
            {
                FlowLayoutPanel targetPanel = selectedSpeciesIds.Contains(species.id) ? selectedPanel : nonSelectedPanel;
                AddSpeciesToPanel(species, targetPanel);
            }
        }

        private void AddSpeciesToPanel(ManagedSpecies species, FlowLayoutPanel panel)
        {
            PictureBox pictureBox = new PictureBox();
            pictureBox.Size = new Size(75, 75);

            Bitmap speciesBitmap = new Bitmap(species.spritePath);
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
                } else
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
                ManagedSpecies species = (ManagedSpecies)panel.Tag;
                selectedSpeciesIds.Add(species.id);
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
