extends State

func Enter() -> void:
	process_mode = PROCESS_MODE_INHERIT;

func Exit() -> void:
	process_mode = PROCESS_MODE_DISABLED;

func Process(_delta : float) -> void:
	if (parent.player == null): return;
	if (parent.position.distance_to(parent.player.position) > 50):
		transitioned.emit(&"Moving");

func Physics_Process(_delta : float) -> void:
	pass;

func Handle_Input(_event : InputEvent) -> void:
	pass;
