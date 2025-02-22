class_name SlimeBoss extends Enemy

func entity_death() -> void:
	var escape : Interactable = load("res://Environment/Escape/Escape.tscn").instantiate();
	escape.position = self.position;
	add_sibling(escape);
	super();
