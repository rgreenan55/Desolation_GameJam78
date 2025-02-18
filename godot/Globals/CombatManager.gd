extends Node

@warning_ignore("unused_signal")
signal initate_combat();
signal selection_action(action : String);
signal turn_made();

var selected_enemy : int = 0;
var turn_order : Array[String] = ["Player", "Enemies"];

var selected_unit : Entity = null;

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("SelectUnit")):
		selection_action.emit("Select");
	if (event.is_action_pressed("SelectPrevUnit")):
		selection_action.emit("Prev");
	if (event.is_action_pressed("SelectNextUnit")):
		selection_action.emit("Next");
	if (event.is_action_pressed("CancelSelection")):
		selection_action.emit("Cancel")

#region Turn Management
func combat_is_ready() -> void:
	start_turn();

func end_combat() -> void:
	pass;

func start_turn() -> void:
	if (DungeonManager.enemies.size() == 0):
		end_combat();
	if (turn_order[0].begins_with("Player")):
		await turn_made;
		await turn_made;
		DungeonManager.player.end_turn();
		pass;
	else: # Enemies
		for enemy in DungeonManager.enemies:
			enemy_action(enemy);

func end_turn() -> void:
	turn_order.push_back(turn_order.pop_front());
	start_turn();
#endregion

#region Player Turn
func player_action(combat_action : String) -> void:
	var player : Player = DungeonManager.player;
	match (combat_action):
		"Attack":
			var enemy : Enemy = await select_enemy();
			if (enemy == null): return;
			player.attack(enemy);
		"Defend":
			var selected : Player = await select_player();
			if (selected == null): return;
			player.defend();
		"Special":
			var enemy : Enemy = await select_enemy();
			if (enemy == null): return;
			player.special(enemy);
		"Mimic":
			var enemy : Enemy = await select_enemy();
			if (enemy == null): return;
			player.mimic(enemy);
	end_turn();

#region Player Selection Utilities
# Actions for Selecting Self
func select_player() -> Player:
	var player : Player = DungeonManager.player;
	selected_unit = player;
	while (true):
		var action : String = await selection_action;
		match (action):
			"Select": break;
			"Cancel": player = null; break;
	selected_unit = null;
	return player;
# Actions for Selecting Enemy		
func select_enemy() -> Enemy:
	var enemies : Array[Enemy] = DungeonManager.enemies;
	var selected_index : int = 0;
	# Await User Input
	while (true):
		selected_unit = enemies[selected_index];
		var action : String = await selection_action;
		match (action):
			"Select": break;
			"Next": selected_index += 1
			"Prev": selected_index -= 1
			"Cancel": selected_index = -1;
		if (selected_index < 0): selected_index = enemies.size()-1;
		if (selected_index > enemies.size()-1): selected_index = 0;
	selected_unit = null;
	if (selected_index == -1): return;
	return enemies[selected_index];
# Retrieves Currently Selected Unit (UI)
func get_selected_unit() -> Entity:
	return selected_unit;
#endregion

#region Enemy Turn
func enemy_action(enemy : Enemy) -> void:
	var player : Player = DungeonManager.player;

#endregion
