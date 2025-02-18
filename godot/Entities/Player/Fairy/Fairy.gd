class_name Fairy extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite
@onready var light: PointLight2D = $Light
@onready var state_machine: StateMachine = $StateMachine

@export var player : Player;
var SPEED : float = 150;
const FLOAT_AMOUNT : float = 48.0

func _ready() -> void:
	connect_player.call_deferred();
	_randomize_float();
		
func connect_player() -> void:
	player = get_node("../Player")
	player.connect("mimic_enemy", enter_mimic);

func enter_combat() -> void:
	state_machine.on_child_transitioned(&"Combat");
func enter_mimic(enemy : Enemy) -> void:
	state_machine.get_node("Mimic").target = enemy.position;
	state_machine.on_child_transitioned(&"Mimic");
func exit_combat() -> void:
	state_machine.on_child_transitioned(&"Idle");
	
func _randomize_float() -> void:
	var tween : Tween = create_tween();
	var offset : Vector2 = Vector2(randf_range(-FLOAT_AMOUNT, FLOAT_AMOUNT), randf_range(-FLOAT_AMOUNT, FLOAT_AMOUNT));
	tween.set_parallel(true);
	tween.tween_property(sprite, "offset", offset, 2);
	tween.tween_property(light, "offset", offset / 7.5, 2);
	await tween.finished
	_randomize_float();
