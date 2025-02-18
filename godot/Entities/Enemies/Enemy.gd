class_name Enemy extends Entity

func entity_death() -> void:
	DungeonManager.remove_enemy(self);
	super();
