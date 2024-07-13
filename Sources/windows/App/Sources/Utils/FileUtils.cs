using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

public static class FileUtils
{
    public static List<string> ListFiles(string directory, string extension)
    {
        List<string> files = new List<string>();

        foreach (var file in Directory.EnumerateFiles(directory))
        {
            if (Path.GetExtension(file).Equals(extension, StringComparison.OrdinalIgnoreCase))
            {
                files.Add(file);
            }
        }

        return files;
    }

    public static string FileName(string path)
    {
        return Path.GetFileNameWithoutExtension(path);
    }
}
