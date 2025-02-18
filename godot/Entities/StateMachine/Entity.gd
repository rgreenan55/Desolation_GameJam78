class_name Entity extends CharacterBody2D

signal health_changed(hp : int, total_hp : int);
signal defence_changed(defence : int);

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Utility
@export var state_machine : StateMachine;
@export var combat_position : Vector2;
@export var combat_card : EntityCard;

# Data
@export var entity_name : String;
@export var ui_texture : Texture;

# Basic Values
@export var SPEED : float = 150.0;

# Combat Values
@export var attack_damage : int = 0;

@export var base_defence : int = 0;
@export var current_defence : int = 0 :
	set(value):
		current_defence = max(0, value);
		defence_changed.emit(current_defence);

@export var total_health : int = 100;
@export var current_health : int = total_health :
	set(value):
		current_health = max(0, value);
		health_changed.emit(current_health, total_health);
		if (current_health <= 0): entity_death();

# Functions
func _ready() -> void:
	state_machine = get_node("StateMachine");

func move_to_combat_position() -> void:
	state_machine.on_child_transitioned(&"EnteringCombat");

func take_damage(_source : Entity, damage : int) -> void:
	current_health -= damage;

func end_turn() -> void:
	current_defence += base_defence;
	# Status Effects?

func entity_death() -> void:
	combat_card.remove_card();
	if (animation_player.is_playing()):
		await animation_player.animation_finished;
	self.queue_free();
	
