namespace App
{
    public class Species
    {
        public string Id { get; set; }
        public string DragPath { get; set; }
        public string MovementPath { get; set; }
        public int ZIndex { get; set; }
        public double Speed { get; set; }
        public double Scale { get; set; }
        public List<SpeciesAnimation> Animations { get; set; }
        public List<string> Capabilities { get; set; }

        public Species(string id, double speed, double scale)
        {
            Id = id;
            Speed = speed;
            Scale = scale;
            DragPath = "drag";
            MovementPath = "walk";
            ZIndex = 0;
            Animations = new List<SpeciesAnimation>();
            Capabilities = new List<string>();
        }
    }
}
