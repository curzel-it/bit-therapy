namespace App
{
    public class SpeciesAnimation
    {
        public string Id { get; set; }
        public string Position { get; set; }
        public List<double> Size { get; set; }
        public int RequiredLoops { get; set; }

        public SpeciesAnimation(string id, string position, List<double> size, int requiredLoops)
        {
            Id = id;
            Position = position;
            Size = size;
            RequiredLoops = requiredLoops;
        }
    }
}
