using System.Collections.Generic;
using System.IO;
using Newtonsoft.Json;

namespace App
{
    public static class AppConfigRepository
    {
        private static string configFilePath = "appConfig.json";

        public static List<string> GetSelectedSpecies()
        {
            if (!File.Exists(configFilePath))
            {
                return new List<string>();
            }

            string json = File.ReadAllText(configFilePath);
            return JsonConvert.DeserializeObject<List<string>>(json);
        }

        public static void SaveSelectedSpecies(List<string> selectedSpecies)
        {
            string json = JsonConvert.SerializeObject(selectedSpecies, Formatting.Indented);
            File.WriteAllText(configFilePath, json);
        }
    }
}
