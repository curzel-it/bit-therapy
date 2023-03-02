
from yage.models.species import Species
from .leaves_breadcrumbs import LeavesBreadcrumbs

class LeavesPoopStains(LeavesBreadcrumbs):
    def __init__(self, subject):
        super().__init__(subject)
        self.species_for_trace_entities = LeavesPoopStains.poop_stain_species()
        self.time_between_spawns = 4
        self.trace_expiration_time = 17 / self.species_for_trace_entities.fps

    @classmethod
    def poop_stain_species(self) -> Species:
        return Species(
            id='poopstain', 
            animations=[], 
            capabilities=[
                "AnimatedSprite",
                "AnimationsProvider",
                "PetsSpritesProvider"
            ], 
            drag_path='front', 
            fps=4, 
            movement_path='front', 
            speed=0, 
            tags=[], 
            z_index=-100
        )