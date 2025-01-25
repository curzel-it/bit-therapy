using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App
{
    public class RandomAnimations : EntityCapability
    {
        private bool isPlayingAnimation;
        private uint timeToNextAnimation;
        private uint timeToResumeMovement;
        private static Random random = new Random();

        public RandomAnimations()
        {
            isPlayingAnimation = false;
            timeToNextAnimation = 10000;
            timeToResumeMovement = 10000;
            ScheduleNextAnimation();
        }

        private void ScheduleNextAnimation()
        {
            double randomDelaySeconds = 10 + (random.Next() % 20);
            timeToNextAnimation = (uint)(randomDelaySeconds * 1000.0);
        }

        public override void Update(TimeSpan timeSinceLastUpdate, Entity entity)
        {
            var frameDuration = (int)timeSinceLastUpdate.TotalMilliseconds;
            var isFalling = entity.Direction.Y != 0;

            if (isPlayingAnimation)
            {
                timeToResumeMovement -= (uint)frameDuration;

                if (timeToResumeMovement < 0)
                {
                    ResumeMovement(entity);
                    ScheduleNextAnimation();
                }
            } else
            {
                timeToNextAnimation -= (uint)frameDuration;

                if (timeToNextAnimation < 0 && !isFalling)
                {
                    PlayRandomAnimation(entity);
                }
            }
        }

        private void ResumeMovement(Entity entity)
        {
            entity.ChangeSprite(entity.Species.MovementPath);
            entity.Direction = new Vector2d(1.0, 0.0);
            isPlayingAnimation = false;
        }

        private void PlayRandomAnimation(Entity entity)
        {
            if (entity.Species.Animations.Count == 0)
            {
                return;
            }
            int randomIndex = random.Next(entity.Species.Animations.Count);
            var animation = entity.Species.Animations[randomIndex];
            PlayAnimation(entity, animation);
        }

        private void PlayAnimation(Entity entity, SpeciesAnimation animation)
        {
            entity.Direction = new Vector2d(0.0, 0.0);
            var loopDuration = entity.ChangeSprite(animation.Id);
            timeToResumeMovement = (uint)(loopDuration * animation.RequiredLoops);
            isPlayingAnimation = true;
        }
    }
}
