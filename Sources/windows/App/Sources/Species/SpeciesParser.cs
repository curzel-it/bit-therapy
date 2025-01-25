using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App
{
    public class SpeciesParser
    {
        private const string SPECIES_ANIMATION_POSITION_FROM_ENTITY_BOTTOM_LEFT = "fromEntityBottomLeft";

        public List<Species> ParseFromFiles(List<String> filePaths) { 
            return filePaths
                .Select(ParseFromFile)
                .Where(x => x != null)
                .ToList();
            }


        public Species? ParseFromFile(string filePath)
        {
            try
            {
                var jsonString = File.ReadAllText(filePath);
                return Parse(jsonString);
            } catch (Exception)
            {
                return null;
            }
        }

        public Species? Parse(String jsonString)
        {
            try
            {
                var json = JObject.Parse(jsonString);
                if (json == null) { return null; }

                var species = new Species(
                    json.GetValue("id")?.ToString() ?? "missingno",
                    (double?)json.GetValue("speed") ?? 1.0,
                    (double?)json.GetValue("scale") ?? 1.0
                );

                species.Capabilities = json.GetValue("capabilities")?.ToObject<List<string>>() ?? new List<string>();
                species.DragPath = json.GetValue("dragPath")?.ToString() ?? "drag";
                species.MovementPath = json.GetValue("movementPath")?.ToString() ?? "walk";
                species.ZIndex = (int?)json.GetValue("zIndex") ?? 0;

                var animations = json.GetValue("animations");
                if (animations != null)
                {
                    foreach (var anim in animations)
                    {
                        if (anim != null) {
                            species.Animations.Add(new SpeciesAnimation(
                                anim["id"]?.ToString() ?? "undefined",
                                anim["position"]?.ToString() ?? SPECIES_ANIMATION_POSITION_FROM_ENTITY_BOTTOM_LEFT,
                                anim["size"]?.ToObject<List<double>>() ?? new List<double> { 1.0, 1.0 },
                                (int?)anim["requiredLoops"] ?? 1
                            ));
                        }
                    }
                }

                return species;
            } catch (Exception e)
            {
                Console.WriteLine($"Failed to parse species: {e.Message}");
                return null;
            }
        }
    }
}
