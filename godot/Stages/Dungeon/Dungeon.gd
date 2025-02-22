extends Node2D

func _ready() -> void:
	CombatManager.setup();
	DungeonManager.generate_dungeon_floor();
	var room = load("res://Stages/Dungeon/Room/DungeonRoom.tscn").instantiate();
	var player : Player = load("res://Entities/Player/Player.tscn").instantiate();
	var fairy : Fairy = load("res://Entities/Player/Fairy/Fairy.tscn").instantiate();
	player.position = get_viewport_rect().size / 2;
	fairy.player = player;
	DungeonManager.player = player;
	DungeonManager.enemies = [];
	
	get_node("UserInterfaces/GameOverlay/CombatUI").add_player_card();
	add_child(room);
	get_node("DungeonRoom").add_child(player);
	get_node("DungeonRoom").add_child(fairy);
	get_node("Utilities/RoomTransition").player = player;
	get_node("Utilities/RoomTransition").fairy = fairy;
	get_node("Utilities/RoomTransition").current_room = room;
	get_node("Utilities/RoomTransition").setup();
