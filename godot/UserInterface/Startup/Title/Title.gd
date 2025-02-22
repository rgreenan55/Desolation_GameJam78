extends Control

const STORY = preload("res://UserInterface/Startup/Story/Story.tscn");

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(STORY)

func _on_exit_button_pressed() -> void:
	get_tree().quit();
