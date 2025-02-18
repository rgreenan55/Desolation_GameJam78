extends Control

const ENTITY_CARD = preload("res://UserInterface/Game/Combat/EntityCard.tscn")
@onready var player_card_slot: HBoxContainer = $EntityCardContainer/HSplitContainer/PlayerCardSlot
@onready var enemy_cards: HBoxContainer = $EntityCardContainer/HSplitContainer/EnemyCards

func _ready() -> void:
	var player_card : EntityCard = ENTITY_CARD.instantiate();
	player_card.connect_to_entity(DungeonManager.player);
	player_card_slot.add_child(player_card);
	CombatManager.initate_combat.connect(show_ui);
	DungeonManager.enemy_added.connect(add_enemy_card);

func show_ui() -> void:
	self.visible = true;
	
func add_enemy_card(enemy : Enemy):
	var enemy_card : EntityCard = ENTITY_CARD.instantiate();
	enemy_card.connect_to_entity(enemy);
	enemy_cards.add_child(enemy_card);
