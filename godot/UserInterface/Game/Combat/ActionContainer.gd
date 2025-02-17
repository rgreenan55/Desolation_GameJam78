extends MarginContainer

var player : Player = DungeonManager.player;

@onready var action_container: MarginContainer = $"."


#region Button Presses
func _on_attack_pressed() -> void:
	action_container.visible = false
	var enemy : Enemy = await get_enemy();
	CombatManager.attack(enemy);
	enemy.on_hit(1);
	action_container.visible = true
	
func _on_defend_pressed() -> void:
	action_container.visible = false
	pass # Replace with function body.
	action_container.visible = true

func _on_special_pressed() -> void:
	action_container.visible = false
	var enemy : Enemy = await get_enemy();
	# Use Special
	action_container.visible = true

func _on_mimic_pressed() -> void:
	action_container.visible = false
	var enemy : Enemy = await get_enemy();
	# Minmic Ability
	action_container.visible = true
#endregion

#region Utilities
func get_enemy() -> Enemy:
	return await CombatManager.select_enemy();
#endregion
