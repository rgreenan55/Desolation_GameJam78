extends Control

const DUNGEON = preload("res://Stages/Dungeon/Dungeon.tscn")

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(DUNGEON)

func _on_exit_button_pressed() -> void:
	get_tree().quit();
