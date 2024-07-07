using System;
using System.Collections.Generic;
using System.Drawing;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using BitTherapyCLR;
using BitTherapyWinForms;

namespace App
{
    internal static class Program
    {
        [DllImport("user32.dll")]
        private static extern bool SetProcessDPIAware();

        private static List<GameForm> gameForms = new List<GameForm>();

        [STAThread]
        static void Main()
        {
            ApplicationConfiguration.Initialize();
            SetProcessDPIAware();
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);

            LoadGameForms();

            Application.Run(new AvailableSpeciesForm(ResourcesHelper.GetSpecies(), ResourcesHelper.GetAssets()));
        }

        private static void LoadGameForms()
        {
            // Close existing forms
            foreach (var form in gameForms)
            {
                form.Close();
                form.Dispose();
            }
            gameForms.Clear();

            var species = ResourcesHelper.GetSpecies();
            var assets = ResourcesHelper.GetAssets();
            var selectedSpecies = AppConfigRepository.GetSelectedSpecies();

            foreach (var screen in Screen.AllScreens)
            {
                var bounds = screen.Bounds;

                ManagedGame game = new ManagedGame(
                    screen.DeviceName,
                    bounds.X, // x
                    bounds.Y, // y
                    bounds.Width, // w
                    bounds.Height, // h
                    1.0, // scaleMultiplier 
                    1.0, // speedMultiplier
                    10.0, // animationFps
                    50.0, // baseEntitySize
                    species, // speciesPaths
                    assets // assetsPaths
                );

                // Add the persisted species to the game
                foreach (var speciesId in selectedSpecies)
                {
                    game.AddEntity(speciesId);
                }

                GameForm gameForm = new GameForm(30.0, game, false);
                gameForms.Add(gameForm);
                gameForm.Show();
            }
        }

        public static void ReloadGameForms()
        {
            LoadGameForms();
        }
    }
}
