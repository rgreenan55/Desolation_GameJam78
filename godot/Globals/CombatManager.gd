extends Node

@warning_ignore("unused_signal")
signal initate_combat;
signal combat_action(action : String);

var selected_enemy : int = 0;
var turn_order : Array[Entity] = [];

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("Enter")):
		combat_action.emit("Select");
	if (event.is_action_pressed("MoveLeft")):
		combat_action.emit("Prev");
	if (event.is_action_pressed("MoveRight")):
		combat_action.emit("Next");

func add_to_turn_order(entity : Entity) -> void:
	turn_order.push_back(entity);

func start_turn() -> void:
	if (turn_order[0].is_in_group("Player")):
		pass;	
	pass;

func end_turn() -> void:
	var entity : Entity = turn_order.pop_front();
	turn_order.push_back(entity);
	start_turn();

func combat_is_ready() -> void:
	start_turn();

func attack(entity_to_damage : Entity) -> void:
	pass;

func select_enemy() -> Enemy:
	var enemies : Array[Enemy] = DungeonManager.enemies;
	var selected_index : int = 0;
	
	while (true):
		var action : String = await combat_action;
		match (action):
			"Select": break;
			"Next": selected_index += 1
			"Prev": selected_index -= 1
		if (selected_index < 0): selected_index = enemies.size()-1;
		if (selected_index > enemies.size()-1): selected_index = 0;
	return enemies[selected_index];
