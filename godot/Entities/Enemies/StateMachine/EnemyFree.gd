extends State

var timer : SceneTreeTimer;

func Enter() -> void:
	process_mode = PROCESS_MODE_INHERIT;
	_randomize_movement();

func Exit() -> void:
	process_mode = PROCESS_MODE_DISABLED;
	if (timer):
		timer.timeout.disconnect(_randomize_movement);

func Process(_delta : float) -> void:
	if (parent.velocity.x > 0): parent.get_node("Sprite").flip_h = false;
	if (parent.velocity.x < 0): parent.get_node("Sprite").flip_h = true;

func Physics_Process(delta : float) -> void:
	var collision : KinematicCollision2D = parent.move_and_collide(parent.velocity * delta);
	if (collision): parent.velocity = parent.velocity.bounce(collision.get_normal());

func Handle_Input(_event : InputEvent) -> void:
	pass;
	
func _randomize_movement() -> void:
	var direction : Vector2 = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	parent.velocity = direction * parent.SPEED;
	timer = get_tree().create_timer(2.0, false);
	timer.timeout.connect(_randomize_movement);	
