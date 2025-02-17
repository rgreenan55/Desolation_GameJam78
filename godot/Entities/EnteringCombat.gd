extends State

func Enter() -> void:
	process_mode = PROCESS_MODE_INHERIT;

func Exit() -> void:
	process_mode = PROCESS_MODE_DISABLED;

func Process(_delta : float) -> void:
	pass;

func Physics_Process(_delta : float) -> void:
	var target_position : Vector2 = parent.combat_position;
	if (parent.position.distance_to(target_position) <= 4):
		parent.position = target_position;
		transitioned.emit(&"Idle");
	else:
		var direction : Vector2 = (target_position - parent.position).normalized();
		parent.velocity = direction * parent.SPEED;
		parent.move_and_slide();

func Handle_Input(_event : InputEvent) -> void:
	pass;
