extends MarginContainer

@onready var action_container: MarginContainer = $"."

@onready var attack_label: Label = $VBoxContainer/Attack/AttackLabel
@onready var defend_label: Label = $VBoxContainer/Defend/DefendLabel
@onready var special_label: Label = $VBoxContainer/Special/SpecialLabel

func _process(_delta: float) -> void:
	self.visible = CombatManager.is_players_turn;
	
	var player : Player = DungeonManager.player;
	if (player):
		special_label.get_parent().disabled = player.special_modifier == null;
		attack_label.text = player.attack_modifier.get_description() if player.attack_modifier else "Deal Damage";
		defend_label.text = player.defence_modifier.get_description() if player.defence_modifier else "Add to Defence";
		special_label.text = player.special_modifier.get_description() if player.special_modifier else "Requires Mimic";
		

func _on_attack_pressed() -> void: initiate_action("Attack");
func _on_defend_pressed() -> void: initiate_action("Defend");
func _on_special_pressed() -> void: initiate_action("Special");
func _on_mimic_pressed() -> void: initiate_action("Mimic");

func initiate_action(action : String) -> void:
	action_container.visible = false
	await CombatManager.player_action(action);
	action_container.visible = true
