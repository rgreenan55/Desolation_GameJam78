extends State

func Enter() -> void:
	process_mode = PROCESS_MODE_INHERIT;

func Exit() -> void:
	process_mode = PROCESS_MODE_DISABLED;

func Process(_delta : float) -> void:
	pass;

func Physics_Process(delta : float) -> void:
	var combat_position : Vector2 = Vector2(parent.player.position.x-32, parent.player.position.y);
	var target_position : Vector2 = (combat_position - parent.position).normalized();
	
	if (parent.position.distance_to(combat_position) < 4):
		parent.velocity = Vector2.ZERO
	else:
		parent.velocity = parent.velocity.lerp(target_position * parent.SPEED, delta * 8);
	parent.move_and_slide();

func Handle_Input(_event : InputEvent) -> void:
	pass;
