extends Control

@onready var background: TextureRect = $Background
@onready var game_over_container: CenterContainer = $GameOverContainer

func fade_to_black() -> void:
	self.visible = true;
	await create_tween().tween_property(background, "modulate:a", 1, 1).finished;
	
func fade_from_black() -> void:
	await create_tween().tween_property(background, "modulate:a", 0, 1).finished;
	self.visible = false;
	
func display_game_over() -> void:
	await fade_to_black();
	game_over_container.visible = true;
	
func _on_return_to_town_pressed() -> void:
	get_tree().change_scene_to_packed(load("res://Stages/Overworld/Overworld.tscn"));

func _on_quit_to_title_pressed() -> void:
	get_tree().change_scene_to_packed(load("res://UserInterface/Startup/Title/Title.tscn"))
