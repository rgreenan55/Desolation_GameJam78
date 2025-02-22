class_name Entity extends CharacterBody2D

# Signals
signal health_changed(hp : int, total_hp : int);
signal defence_changed(defence : int);

# Node References
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: StateMachine = $StateMachine

# ----------------------------------------------------------------------------------------------------------

# Meta Data / Utility
@export var entity_name : String;
@export var ui_texture : Texture;
@export var combat_position : Vector2;
@export var combat_card : EntityCard;

# Basic Values
@export var SPEED : float = 150.0;

# Combat Stats
@export var attack_damage : int = 0;

@export var base_defence : int = 0;
@export var current_defence : int = 0 :
	set(value):
		current_defence = max(0, value);
		defence_changed.emit(current_defence);

@export var total_health : int = 100;
@export var current_health : int = 1 :
	set(value):
		value = min(value, total_health);
		current_health = max(0, value);
		health_changed.emit(current_health, total_health);
		if (current_health <= 0): entity_death();

# Modifier Resources
@export var attack_modifier : AttackModifier;
@export var defence_modifier : DefendModifier;
@export var special_modifier : SpecialModifier;

# ----------------------------------------------------------------------------------------------------------

func _ready() -> void:
	current_health = total_health;

func move_to_combat_position() -> void:
	state_machine.on_child_transitioned(&"EnteringCombat");

func end_turn() -> void:
	if (current_defence < base_defence):
		current_defence = base_defence;
	# Status Effects?

# Combat Actions
func take_damage(source : Entity, damage : int) -> void:
	if (current_defence > 0 && defence_modifier):
		damage = defence_modifier.apply_modification(damage, self, source);
	var remaining_damage = calculate_damage(damage);
	current_defence = max(0, current_defence-damage);
	current_health -= remaining_damage;

func take_flat_damage(_source : Entity, damage : int) -> void:
	current_health -= damage;
	
func heal_damage(heal_amount : int) -> void:
	current_health += heal_amount;

func attack(target : Entity) -> void:
	var damage = attack_damage;
	if (attack_modifier):
		damage = attack_modifier.apply_modification(damage, self, target);
	target.take_damage(self, damage);
	
func defend() -> void:
	current_defence += base_defence;

func special(_target : Entity) -> void:
	pass;

func entity_death() -> void:
	combat_card.remove_card();
	if (animation_player.is_playing()):
		await animation_player.animation_finished;
	self.queue_free();

# ----------------------------------------------------------------------------------------------------------

func calculate_damage(damage : int) -> int:
	return max(0, damage-current_defence);
	
