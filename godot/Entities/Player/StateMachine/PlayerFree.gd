extends State

func Enter() -> void:
	process_mode = PROCESS_MODE_INHERIT;

func Exit() -> void:
	process_mode = PROCESS_MODE_DISABLED;

func Process(_delta : float) -> void:
	pass;

func Physics_Process(_delta : float) -> void:
	var direction : Vector2 = Input.get_vector("MoveLeft", "MoveRight", "MoveUp", "MoveDown");
	parent.velocity = direction * parent.SPEED;
	parent.move_and_slide();

func Handle_Input(_event : InputEvent) -> void:
	pass;

func _on_enemy_detector_body_entered(body: Node2D) -> void:
	if (body.is_in_group("Enemy")):
		CombatManager.initate_combat.emit();
