extends State

func Enter() -> void:
	process_mode = PROCESS_MODE_INHERIT;
	parent.velocity = Vector2.ZERO;
	CombatManager.finish_combat.connect(func(): transitioned.emit(&"Free"));
	parent.get_node("Sprite").flip_h = false;
