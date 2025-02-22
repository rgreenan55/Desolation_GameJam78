extends State

func Enter() -> void:
	process_mode = PROCESS_MODE_INHERIT;
	parent.defend();

func Exit() -> void:
	process_mode = PROCESS_MODE_DISABLED;
	DungeonManager.fairy.enter_combat();

func Process(_delta : float) -> void:
	pass;

func Physics_Process(_delta : float) -> void:
	var target_position : Vector2 = parent.combat_position;
	if (parent.position.distance_to(target_position) <= 4):
		parent.position = target_position;
		transitioned.emit(&"Combat");
	else:
		var direction : Vector2 = (target_position - parent.position).normalized();
		parent.velocity = direction * parent.SPEED * 2;
		parent.move_and_slide();

func Handle_Input(_event : InputEvent) -> void:
	pass;
