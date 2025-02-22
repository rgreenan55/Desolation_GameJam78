extends Interactable

func interact() -> void:
	get_tree().change_scene_to_packed(load("res://Stages/Overworld/Overworld.tscn"));
