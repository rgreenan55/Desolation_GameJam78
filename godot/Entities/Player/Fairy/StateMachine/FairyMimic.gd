extends State

@export var target : Vector2;

func Enter() -> void:
	process_mode = PROCESS_MODE_INHERIT;
	var original_position : Vector2 = parent.position;
	var tween : Tween = create_tween();
	tween.set_ease(Tween.EASE_IN_OUT);
	tween.tween_property(parent, "position", Vector2(target.x - 32, target.y), 1);
	tween.tween_interval(0.20);
	tween.tween_property(parent, "position", Vector2(target.x + 32, target.y), 0.2);
	tween.tween_interval(0.20);
	tween.tween_property(parent, "position", original_position, 1);
	await tween.finished;
	transitioned.emit(&"Combat")

func Exit() -> void:
	process_mode = PROCESS_MODE_DISABLED;
