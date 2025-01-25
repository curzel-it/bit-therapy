using System;

namespace App.Sources.Utils
{

    public class ResourcesHelper
    {
        public static List<string> GetSpecies()
        {
            string folderPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Species");
            List<string> jsonFileList = new List<string>();

            if (Directory.Exists(folderPath))
            {
                string[] jsonFiles = Directory.GetFiles(folderPath, "*.json", SearchOption.TopDirectoryOnly);
                jsonFileList.AddRange(jsonFiles);
            }
            else
            {
                throw new DirectoryNotFoundException("The directory does not exist.");
            }

            return jsonFileList;
        }

        public static List<string> GetAssets()
        {
            string folderPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "PetsAssets");
            List<string> jsonFileList = new List<string>();

            if (Directory.Exists(folderPath))
            {
                string[] jsonFiles = Directory.GetFiles(folderPath, "*.png", SearchOption.TopDirectoryOnly);
                jsonFileList.AddRange(jsonFiles);
            }
            else
            {
                throw new DirectoryNotFoundException("The directory does not exist.");
            }

            return jsonFileList;
        }
    }
}