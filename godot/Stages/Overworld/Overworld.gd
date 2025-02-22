extends Node2D

@onready var world_things: Node2D = $WorldThings

func _ready() -> void:
	var player : Player = load("res://Entities/Player/Player.tscn").instantiate();
	player.add_child(Camera2D.new());
	world_things.get_node("Fairy").player = player;
	world_things.add_child(player);
	
