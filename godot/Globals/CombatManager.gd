extends Node

@warning_ignore("unused_signal")
signal initate_combat();
signal finish_combat();

signal action_performed(entity_name : String, action : String);

signal selection_action(action : String);
signal turn_made();

var turn_order : Array[String] = ["Player", "Player", "Enemies"];
var selected_unit : Entity = null;

var in_combat : bool = false;
var is_players_turn : bool = false;

func setup() -> void:
	turn_order = ["Player", "Player", "Enemies"];
	selected_unit = null;
	in_combat = false;
	is_players_turn = false;

func _input(event: InputEvent) -> void:
	if (!in_combat): return;
	if (event.is_action_pressed("SelectUnit")):
		selection_action.emit("Select");
	if (event.is_action_pressed("SelectPrevUnit")):
		selection_action.emit("Prev");
	if (event.is_action_pressed("SelectNextUnit")):
		selection_action.emit("Next");
	if (event.is_action_pressed("CancelSelection")):
		get_viewport().set_input_as_handled();
		selection_action.emit("Cancel")

#region Turn Management
func combat_is_ready() -> void:
	in_combat = true;
	start_turn();
func end_combat() -> void:
	if (in_combat):
		in_combat = false;
		finish_combat.emit();

func start_turn() -> void:
	if (DungeonManager.enemies.size() == 0):
		end_combat();
	if (turn_order[0] == "Player"):
		is_players_turn = true;
		await turn_made;
		if (turn_order[1] == "Enemies"):
			DungeonManager.player.end_turn();
	else:
		await create_tween().tween_interval(1).finished;
		for enemy in DungeonManager.enemies:
			await enemy_action(enemy);
			enemy.end_turn();
		end_turn();

func end_turn() -> void:
	turn_order.push_back(turn_order.pop_front());
	start_turn();
#endregion

#region Player Turn
func player_action(combat_action : String) -> void:
	var player : Player = DungeonManager.player;
	is_players_turn = false;
	match (combat_action):
		"Attack":
			var enemy : Enemy = await select_enemy();
			if (enemy == null): return;
			action_performed.emit("Player", "Attack");
			await create_tween().tween_interval(1).finished;
			player.attack(enemy);
		"Defend":
			var selected : Player = await select_player();
			if (selected == null): return;
			action_performed.emit("Player", "Defend");
			await create_tween().tween_interval(1).finished;
			player.defend();
		"Special":
			var enemy : Enemy = await select_enemy();
			if (enemy == null): return;
			action_performed.emit("Player", "Special");
			await create_tween().tween_interval(1).finished;
			player.special(enemy);
		"Mimic":
			var enemy : Enemy = await select_enemy();
			if (enemy == null): return;
			action_performed.emit("Player", "Mimic");
			player.mimic(enemy);
			await create_tween().tween_interval(2).finished;
	turn_made.emit();
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
			"Cancel":
				is_players_turn = true;
				player = null;
				break;
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
			"Cancel":
				selected_unit = null;
				is_players_turn = true;
				return;
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
	var action : String = enemy.get_enemy_action_decision();
	match (action):
		"Attack": 
			action_performed.emit(enemy.name, "Attack");
			await create_tween().tween_interval(1).finished;
			enemy.attack(player);
		"Defend":
			action_performed.emit(enemy.name, "Defend");
			await create_tween().tween_interval(1).finished;
			enemy.defend();
		_:
			action_performed.emit(enemy.name, "Nothing");
			await create_tween().tween_interval(1).finished;		
	await create_tween().tween_interval(1).finished;
#endregion
