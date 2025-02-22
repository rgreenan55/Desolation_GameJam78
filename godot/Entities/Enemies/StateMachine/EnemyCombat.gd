extends State


func Enter() -> void:
	process_mode = PROCESS_MODE_INHERIT;
	parent.get_node("Sprite").flip_h = true;
