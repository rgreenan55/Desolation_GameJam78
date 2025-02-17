extends CharacterBody2D

# Constants
const SPEED = 150

# Nodes
@onready var sprite: Sprite2D = $Sprite

func _process(_delta: float) -> void:
	handle_sprite();
	
func handle_sprite() -> void:
	if (velocity.x < 0): sprite.flip_h = true;
	if (velocity.x > 0): sprite.flip_h = false;
