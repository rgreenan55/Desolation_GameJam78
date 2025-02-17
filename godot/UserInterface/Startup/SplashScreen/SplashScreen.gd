extends Control

# Nodes
@onready var splash_art : CenterContainer = $SplashArt

# Scene to Go To
@export var load_scene : PackedScene = preload("res://UserInterface/Startup/Title/Title.tscn")

func _ready() -> void:
	splash_art.modulate.a = 0.0;
	
	# Init Tween
	var tween : Tween = self.create_tween();
	tween.tween_interval(0.5);
	tween.tween_property(splash_art, "modulate:a", 1.0, 1.5);
	tween.tween_interval(1.5);
	tween.tween_property(splash_art, "modulate:a", 0.0, 0.5);
	tween.tween_interval(0.5);
	# Load Next Scene
	await tween.finished;
	next_scene();

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_pressed()): next_scene();

func next_scene() -> void:
	get_tree().change_scene_to_packed(load_scene);
