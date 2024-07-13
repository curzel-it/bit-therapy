using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App
{
    public class SpeciesRepository
    {
        private readonly SpeciesParser _parser;
        private Dictionary<string, Species> _speciesById;

        public SpeciesRepository(SpeciesParser parser)
        {
            _parser = parser;
            _speciesById = new Dictionary<String, Species>();
        }

        public void Setup(List<String> paths)
        {
            _speciesById = _parser
                .ParseFromFiles(paths)
                .GroupBy(species => species.Id)
                .ToDictionary(group => group.Key, group => group.First());
        }

        public uint NumberOfAvailableSpecies() => (uint)_speciesById.Count;

        public Species? GetSpecies(string speciesId)
        {
            if (_speciesById.TryGetValue(speciesId, out var species))
            {
                return species;
            }
            return null;
        }

        public List<string> AvailableSpecies() => _speciesById.Keys.ToList();
    }
}
