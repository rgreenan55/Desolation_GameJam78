extends State

func Enter() -> void:
	process_mode = PROCESS_MODE_INHERIT;

func Exit() -> void:
	process_mode = PROCESS_MODE_DISABLED;

func Process(_delta : float) -> void:
	if (parent.position.distance_to(parent.player.position) < 25):
		transitioned.emit(&"Idle");

func Physics_Process(delta : float) -> void:
	var target_position : Vector2 = (parent.player.position - parent.position).normalized();
	parent.velocity = parent.velocity.lerp(target_position * parent.SPEED, delta * 8);
	parent.move_and_slide();

func Handle_Input(_event : InputEvent) -> void:
	pass;
