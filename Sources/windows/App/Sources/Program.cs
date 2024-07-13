using System;
using System.Collections.Generic;
using System.Drawing;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using App.Sources.Utils;

namespace App
{
    internal static class Program
    {
        [DllImport("user32.dll")]
        private static extern bool SetProcessDPIAware();

        private static List<GameForm> gameForms = new List<GameForm>();

        private static SpeciesParser speciesParser;
        private static SpeciesRepository speciesRepo;
        private static SpriteSetBuilder spriteSetBuilder;
        private static SpritesRepository spritesRepo;
        private static PetsBuilder petsBuilder;

        private static double animationFps = 10.0;
        private static double baseSize = 50.0;
        private static double scaleMultiplier = 1.0;
        private static double speedMultiplier = 1.0;

        [STAThread]
        static void Main()
        {
            ApplicationConfiguration.Initialize();
            SetProcessDPIAware();
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);

            var species = ResourcesHelper.GetSpecies();
            var assets = ResourcesHelper.GetAssets();

            speciesParser = new SpeciesParser();
            speciesRepo = new SpeciesRepository(speciesParser);
            spriteSetBuilder = new SpriteSetBuilder();
            spritesRepo = new SpritesRepository(spriteSetBuilder);
            petsBuilder = new PetsBuilder(speciesRepo, spritesRepo, animationFps, baseSize, scaleMultiplier, speedMultiplier);

            spritesRepo.Setup(assets);
            speciesRepo.Setup(species);

            LoadGameForms();

            Application.Run(new AvailableSpeciesForm(speciesRepo, spritesRepo));
        }

        private static void LoadGameForms()
        {
            var selectedSpecies = AppConfigRepository.GetSelectedSpecies();

            // Close existing forms
            foreach (var form in gameForms)
            {
                form.Close();
                form.Dispose();
            }
            gameForms.Clear();

            foreach (var screen in Screen.AllScreens)
            {
                var bounds = new App.Rect(screen.Bounds.X, screen.Bounds.Y, screen.Bounds.Width, screen.Bounds.Height);

                Game game = new Game(screen.DeviceName, bounds);

                // Add the persisted species to the game
                foreach (var speciesId in selectedSpecies)
                {
                    var entity = petsBuilder.Build(speciesId, bounds);
                    if (entity != null) {
                        game.AddEntity(entity);
                    }
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
