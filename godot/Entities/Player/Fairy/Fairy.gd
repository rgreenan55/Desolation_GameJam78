class_name Fairy extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite
@onready var light: PointLight2D = $Light

@export var player : CharacterBody2D;
const SPEED : int = 150;
const FLOAT_AMOUNT : float = 48.0

var moving_toward_player : bool = false;

func _ready() -> void:
	(func(): player = get_node("../Player")).call_deferred();
	_randomize_float();

func _process(_delta: float) -> void:
	if (player == null): return;
	if (self.position.distance_to(player.position) > 50):
		moving_toward_player = true;
	elif (self.position.distance_to(player.position) < 25):
		moving_toward_player = false;
		
func _physics_process(delta: float) -> void:
	if (moving_toward_player):
		var target_position : Vector2 = (player.position - self.position).normalized();
		self.velocity = self.velocity.lerp(target_position * SPEED, delta * 8);
	else:
		self.velocity = self.velocity.lerp(Vector2.ZERO, delta * 4);
	move_and_slide()
	
func _randomize_float() -> void:
	var tween : Tween = create_tween();
	var offset : Vector2 = Vector2(randf_range(-FLOAT_AMOUNT, FLOAT_AMOUNT), randf_range(-FLOAT_AMOUNT, FLOAT_AMOUNT));
	tween.set_parallel(true);
	tween.tween_property(sprite, "offset", offset, 2);
	tween.tween_property(light, "offset", offset / 7.5, 2);
	await tween.finished
	_randomize_float();
