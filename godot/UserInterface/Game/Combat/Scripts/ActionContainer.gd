extends MarginContainer

@onready var action_container: MarginContainer = $"."

func _on_attack_pressed() -> void: initiate_action("Attack");
func _on_defend_pressed() -> void: initiate_action("Defend");
func _on_special_pressed() -> void: initiate_action("Special");
func _on_mimic_pressed() -> void: initiate_action("Mimic");

func initiate_action(action : String) -> void:
	action_container.visible = false
	await CombatManager.player_action(action);
	action_container.visible = true
