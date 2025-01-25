using App;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App
{
    public class Game
    {
        private readonly object _lock = new object();
        private readonly List<Entity> entities = new List<Entity>();

        public string ScreenName { get; }
        public Rect Bounds { get; }

        public Game(string screenName, Rect bounds)
        {
            ScreenName = screenName;
            Bounds = bounds;
        }

        public void Update(TimeSpan timeSinceLastUpdate)
        {
            lock (_lock)
            {
                foreach (var entity in entities)
                {
                    entity.Update(timeSinceLastUpdate);
                }
            }
        }

        public void AddEntity(Entity entity)
        {
            lock (_lock)
            {
                entities.Add(entity);
            }
        }

        public void AddEntities(IEnumerable<Entity> entities)
        {
            lock (_lock)
            {
                this.entities.AddRange(entities);
            }
        }

        public uint NumberOfEntities()
        {
            lock (_lock)
            {
                return (uint)entities.Count;
            }
        }

        public List<RenderedItem> Render()
        {
            lock (_lock)
            {
                var renderedItems = new List<RenderedItem>();
                foreach (var entity in entities)
                {
                    var item = new RenderedItem(
                        entity.Id,
                        entity.CurrentSpriteFrame(),
                        entity.Frame,
                        IsFlipped(entity),
                        Rotation(entity)
                    );
                    renderedItems.Add(item);
                }
                return renderedItems;
            }
        }

        private bool IsFlipped(Entity entity)
        {
            return entity.Direction.X < 0.0;
        }

        private double Rotation(Entity entity)
        {
            if (entity.Direction.X == 0.0 && entity.Direction.Y == 0.0)
            {
                return 0.0;
            }
            if (entity.Direction.X == 0.0 && entity.Direction.Y < 0.0)
            {
                return 1.5 * Math.PI;
            }
            if (entity.Direction.X == 0.0 && entity.Direction.Y > 0.0)
            {
                return 0.5 * Math.PI;
            }
            if (entity.Direction.X <= 0.0 && entity.Direction.Y == 0.0 && entity.Frame.Y == Bounds.Y)
            {
                return Math.PI;
            }
            return 0.0;
        }

        public void MouseDragStarted(uint targetId)
        {
            lock (_lock)
            {
                foreach (var entity in entities)
                {
                    if (entity.Id == targetId)
                    {
                        var dragSprite = entity.Species.DragPath;
                        entity.Direction = new Vector2d(0.0, 0.0);
                        entity.ChangeSprite(dragSprite);
                    }
                }
            }
        }

        public void MouseDragEnded(uint targetId, float deltaX, float deltaY)
        {
            lock (_lock)
            {
                foreach (var entity in entities)
                {
                    if (entity.Id == targetId)
                    {
                        var dx = deltaX > 0 ? 1.0 : -1.0;
                        var movementSprite = entity.Species.MovementPath;

                        var newFrame = entity.Frame.Offset(deltaX, deltaY);
                        newFrame.X = Math.Max(entity.Frame.X, 0.0);
                        newFrame.X = Math.Min(entity.Frame.X, Bounds.W - entity.Frame.W);
                        newFrame.Y = Math.Max(entity.Frame.Y, 0.0);
                        newFrame.Y = Math.Min(entity.Frame.Y, Bounds.H - entity.Frame.H);
                        entity.Frame = newFrame;
                        entity.Direction = new Vector2d(dx, 0.0);
                        entity.ChangeSprite(movementSprite);
                    }
                }
            }
        }

        public string Description()
        {
            lock (_lock)
            {
                var sb = new StringBuilder();

                sb.AppendLine($"Game @ {this}");
                sb.AppendLine($"  Screen: {ScreenName}");
                sb.AppendLine($"  Origin: {Bounds.X}, {Bounds.Y}");
                sb.AppendLine($"  Size: {Bounds.W} x {Bounds.H}");
                sb.AppendLine($"  Entities: {entities.Count}");
                sb.AppendLine();

                foreach (var entity in entities)
                {
                    sb.AppendLine(entity.Description());
                }
                return sb.ToString();
            }
        }
    }
}
