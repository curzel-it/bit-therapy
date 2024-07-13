using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App
{
    public class SpritesRepository
    {
        private readonly SpriteSetBuilder builder;
        private Dictionary<string, SpriteSet> spriteSets;

        public SpritesRepository(SpriteSetBuilder builder)
        {
            this.builder = builder;
            this.spriteSets = new Dictionary<string, SpriteSet>();
        }

        public void Setup(List<string> pngPaths)
        {
            spriteSets = builder.BuildSpriteSets(pngPaths);
        }

        public SpriteSet? GetSprites(string speciesId)
        {
            return spriteSets.TryGetValue(speciesId, out var spriteSet) ? spriteSet : (SpriteSet?)null;
        }
    }
}
