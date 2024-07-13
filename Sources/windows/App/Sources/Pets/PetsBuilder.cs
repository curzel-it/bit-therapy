using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App
{
    public class PetsBuilder
    {
        private uint nextId;
        private readonly SpeciesRepository speciesRepo;
        private readonly SpritesRepository spritesRepo;
        private readonly double animationFps;
        private readonly double baseSize;
        private readonly double scaleMultiplier;
        private readonly double speedMultiplier;

        public PetsBuilder(
            SpeciesRepository speciesRepo,
            SpritesRepository spritesRepo,
            double animationFps,
            double baseSize,
            double scaleMultiplier,
            double speedMultiplier
        )
        {
            nextId = 1000;
            this.speciesRepo = speciesRepo;
            this.spritesRepo = spritesRepo;
            this.animationFps = animationFps;
            this.baseSize = baseSize;
            this.scaleMultiplier = scaleMultiplier;
            this.speedMultiplier = speedMultiplier;
        }

        public Entity? Build(string speciesId, Rect gameBounds)
        {
            var speciesOpt = speciesRepo.GetSpecies(speciesId);
            var spritesOpt = spritesRepo.GetSprites(speciesId);

            if (speciesOpt == null || spritesOpt == null)
            {
                Console.Error.WriteLine($"Species `{speciesId}` not found!");
                return null;
            }
            var species = speciesOpt;
            var sprites = spritesOpt;

            var frame = new Rect(
                new Random().Next((int)gameBounds.W),
                1.0,
                baseSize * species.Scale * scaleMultiplier,
                baseSize * species.Scale * scaleMultiplier
            );

            var entity = new Entity(++nextId, animationFps, speedMultiplier, species, sprites, frame);

            bool isWallCrawler = species.Capabilities.Contains("WallCrawler");

            entity.AddCapability(new RandomAnimations());
            entity.AddCapability(new LinearMovement());
            entity.AddCapability(new Gravity(gameBounds.H));

            if (isWallCrawler)
            {
                entity.AddCapability(new WallCrawler(gameBounds));
            } else
            {
                entity.AddCapability(new BounceWhenLateralBoundIsHit(0, gameBounds.W));
            }

            return entity;
        }
    }
}
