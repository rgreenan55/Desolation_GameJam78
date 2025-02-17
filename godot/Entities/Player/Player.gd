class_name Player extends Entity

# Nodes
@onready var sprite: Sprite2D = $Sprite

func _process(_delta: float) -> void:
	handle_sprite();
	
func handle_sprite() -> void:
	if (velocity.x < 0): sprite.flip_h = true;
	if (velocity.x > 0): sprite.flip_h = false;

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_left")):
		health -= 1;

func entity_death() -> void:
	print("Player Died");
