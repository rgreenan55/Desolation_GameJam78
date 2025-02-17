class_name Entity extends CharacterBody2D

signal health_changed(hp : int, total_hp : int);

# Utility
@export var state_machine : StateMachine;
@export var combat_position : Vector2;

# Data
@export var entity_name : String;
@export var ui_texture : Texture;

# Values
@export var SPEED : float = 150.0;
@export var damage : int = 0;
@export var total_health : int = 10;
@export var health : int = total_health :
	set(value):
		health = value;
		health_changed.emit(health, total_health);
		if (health == 0): entity_death();

func _ready() -> void:
	state_machine = get_node("StateMachine");

func move_to_combat_position() -> void:
	state_machine.on_child_transitioned(&"EnteringCombat");

# Combat Actions
func on_attack() -> int:
	return damage;

func on_hit(damage : int) -> void:
	health -= damage;

func entity_death() -> void:
	pass;
	
