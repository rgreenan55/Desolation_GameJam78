extends Control

const ENTITY_CARD = preload("res://UserInterface/Game/Combat/EntityCard.tscn")
@onready var player_card_slot: HBoxContainer = $EntityCardContainer/HSplitContainer/PlayerCardSlot
@onready var enemy_cards: HBoxContainer = $EntityCardContainer/HSplitContainer/EnemyCards
@onready var action_label: Label = $ActionLabel

func _ready() -> void:
	CombatManager.initate_combat.connect(show_ui);
	CombatManager.finish_combat.connect(hide_ui);
	DungeonManager.enemy_added.connect(add_enemy_card);
	CombatManager.action_performed.connect(_display_action);

func add_player_card() -> void:
	var player_card : EntityCard = ENTITY_CARD.instantiate();
	player_card.connect_to_entity(DungeonManager.player);
	player_card_slot.add_child(player_card);

func show_ui() -> void: self.visible = true;
func hide_ui() -> void: self.visible = false;

func _display_action(entity : String, action : String) -> void:
	action_label.text = entity + " used " + action + ".";
	await get_tree().create_timer(1).timeout;
	action_label.text = "";

func add_enemy_card(enemy : Enemy):
	var enemy_card : EntityCard = ENTITY_CARD.instantiate();
	enemy_card.connect_to_entity(enemy);
	enemy_cards.add_child(enemy_card);
