extends State

func Enter() -> void:
	parent.get_node("Sprite").flip_h = false;
	process_mode = PROCESS_MODE_INHERIT;

func Exit() -> void:
	process_mode = PROCESS_MODE_DISABLED;

func Process(_delta : float) -> void:
	pass;

func Physics_Process(_delta : float) -> void:
	pass;

func Handle_Input(_event : InputEvent) -> void:
	pass;
