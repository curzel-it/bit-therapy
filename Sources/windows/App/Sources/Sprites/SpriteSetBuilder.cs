using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace App
{
    public class SpriteSetBuilder
    {
        public Dictionary<string, SpriteSet> BuildSpriteSets(List<string> paths)
        {
            var frames = GetSpriteFramesFromPaths(paths);
            var framesBySpecies = AggregateFramesBySpecies(frames);

            var setsBySpecies = new Dictionary<string, SpriteSet>();

            foreach (var (species, framesList) in framesBySpecies)
            {
                var set = CreateSpriteSet(framesList);
                if (set != null)
                {
                    setsBySpecies[species] = set;
                }
            }

            return setsBySpecies;
        }

        private Dictionary<string, List<SpriteFrame>> AggregateFramesBySpecies(List<SpriteFrame> frames)
        {
            return frames.GroupBy(frame => frame.Species)
                         .ToDictionary(group => group.Key, group => group.ToList());
        }

        private List<SpriteFrame> GetSpriteFramesFromPaths(List<string> paths)
        {
            var frames = paths.Select(path => GetSpriteFrameFromPath(path))
                              .Where(frame => frame.HasValue)
                              .Select(frame => frame.Value)
                              .ToList();

            frames.Sort((a, b) => string.Compare(a.Species, b.Species, StringComparison.Ordinal) switch
            {
                0 => string.Compare(a.Animation, b.Animation, StringComparison.Ordinal) switch
                {
                    0 => a.Index.CompareTo(b.Index),
                    var res => res
                },
                var res => res
            });

            return frames;
        }

        private SpriteSet? CreateSpriteSet(List<SpriteFrame> frames)
        {
            var framesByAnimation = frames.GroupBy(frame => frame.Animation)
                                          .ToDictionary(group => group.Key, group => group.Select(frame => frame.Path).ToList());

            return new SpriteSet(framesByAnimation);
        }

        private SpriteFrame? GetSpriteFrameFromPath(string path)
        {
            var regex = new Regex(@"^(.+?)_([a-zA-Z]+)-([0-9]+)$");
            var match = regex.Match(System.IO.Path.GetFileNameWithoutExtension(path));

            if (match.Success && int.TryParse(match.Groups[3].Value, out var index) && index >= 0)
            {
                return new SpriteFrame
                {
                    Path = path,
                    Species = match.Groups[1].Value,
                    Animation = match.Groups[2].Value,
                    Index = (uint)index
                };
            }

            return null;
        }
    }
}
