class_name Player extends Entity

signal mimic_enemy(enemy : Enemy);

# Nodes
@onready var sprite: Sprite2D = $Sprite
@onready var area_detector: Area2D = $AreaDetector
@onready var player_ui: MarginContainer = $PlayerUIContainer/PlayerUI

func _ready() -> void:
	total_health = 100 + GameManager.health * 10;
	current_health = total_health;
	attack_damage = 20 + GameManager.attack * 5;
	base_defence = 5 + GameManager.defence;

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("DEVKEY")):
		current_health = 0;

func _process(_delta: float) -> void:
	handle_sprite();

func handle_sprite() -> void:
	if (state_machine.current_state.name == &"Combat"): sprite.flip_h = false;
	elif (velocity.x < 0): sprite.flip_h = true;
	elif (velocity.x > 0): sprite.flip_h = false;
	
	if (velocity == Vector2.ZERO): animation_player.play("idle");
	else: animation_player.play("moving");
	
func mimic(target : Enemy) -> void:
	mimic_enemy.emit(target); # Signal Fairy Animation
	var modifier : ActionModifier = target.get_modifier();
	if (modifier == null): return;
	
	if (modifier is AttackModifier): self.attack_modifier = modifier;
	if (modifier is DefendModifier): self.defence_modifier = modifier;
	if (modifier is SpecialModifier): self.special_modifier = modifier;
	
# Game Actions
func entity_death() -> void:
	CombatManager.end_combat();
	state_machine.on_child_transitioned(&"GameOver");
