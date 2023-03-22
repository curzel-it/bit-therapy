from rx.subject import BehaviorSubject


class Config:
    def __init__(self, **kwargs):
        self.desktop_interactions = BehaviorSubject(
            kwargs.get('desktop_interactions') or True
        )
        self.gravity_enabled = BehaviorSubject(
            kwargs.get('gravity_enabled') or True
        )
        self.pet_size = BehaviorSubject(
            kwargs.get('pet_size') or 75
        )
        self.selected_species = BehaviorSubject(
            kwargs.get('selected_species') or ['cat_blue']
        )
        self.speed_multiplier = BehaviorSubject(
            kwargs.get('speed_multiplier') or 1
        )

    def toggle_species_selected(self, species_id: str):
        values = self.selected_species.value
        if species_id in values:
            values.remove(species_id)
        else:
            values.append(species_id)
        self.selected_species.on_next(values)
