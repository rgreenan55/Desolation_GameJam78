class_name DungeonGenerator extends Resource

var min_rooms : int = 12;
var max_rooms : int = 15;

var directions : Array[Vector2] = [ Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN];

func generate(current_floor : int) -> Dictionary:
	var entrance : Room = Room.new();
	entrance.room_type = entrance.RoomType.Entrance;
	var dungeon : Dictionary = { Vector2(0, 0) : { "room": entrance, "distance": 0, "room_type": "Entrance", "visited": false } };
	var remaining : int = randi_range(min_rooms, max_rooms);
	var boss_pos : Vector2 = Vector2.ZERO;
	
	# Create Dungeon Layout
	while (remaining > 0):
		for room_pos : Vector2 in dungeon.keys():
			# Randomize Room Creation
			if (randi_range(0, 100) > 50): continue;
			
			# Randomize Room Direction
			var direction : Vector2 = directions.pick_random();
			var new_room_pos : Vector2 = room_pos + direction;
			if (dungeon.has(new_room_pos)): continue;
			
			# Create New Room
			var new_room : Room = Room.new();
			dungeon[new_room_pos] = { "room": new_room, "distance": dungeon[room_pos]["distance"]+1, "room_type": "Empty" };
			
			# Setup Connection
			dungeon[room_pos]["room"].connections[direction] = true;
			new_room.connections[-direction] = true;
			
			# Is Boss Room ?
			if (dungeon[new_room_pos]["distance"] > dungeon[boss_pos]["distance"]):
				boss_pos = new_room_pos;
			
			# Reduce Remaining
			remaining -= 1;
			if (remaining == 0): break;
	
	# Apply Boss Room
	dungeon[boss_pos].room_type = "Boss";
	dungeon[boss_pos].boss_distance = 0;
	dungeon[boss_pos].enemy_data = { "position" : Vector2(640, 360) / 2, "alive" : true }
	
	# Apply Key Room
	var key_pos : Vector2 = boss_pos;
	var key_check : Array[Vector2] = [boss_pos];
	while (!key_check.is_empty()):
		var current : Vector2 = key_check.pop_front();
		var room : Dictionary = dungeon[current];
		var boss_distance = room.boss_distance;
		for connection : Vector2 in room.room.connections:
			var position : Vector2 = current+connection;
			if (dungeon[position].has("boss_distance")): continue;
			dungeon[position].boss_distance = boss_distance+1
			if (boss_distance+1 > dungeon[key_pos].boss_distance):
				key_pos = position;
			key_check.push_back(position);
	dungeon[key_pos].room_type = "Key";
	
	# Apply Chest Rooms
	var remaining_chest_rooms = 3;
	while (remaining_chest_rooms > 0):
		for room : Dictionary in dungeon.values():
			if (room["room_type"] != "Empty" || room["distance"] < 2): continue;
			if (randi_range(0, 100) > 50):
				room["room_type"] = "Chest";
				room["chest"] = { "opened" : false }
				remaining_chest_rooms -= 1;
			if (remaining_chest_rooms == 0): break;

	# Apply Enemy Rooms
	var remaining_enemy_rooms = 6;
	while (remaining_enemy_rooms > 0):
		for room : Dictionary in dungeon.values():
			if (room["room_type"] != "Empty"): continue;
			if (randi_range(0, 100) > 50):
				_generate_enemy_room(room, current_floor);
				remaining_enemy_rooms -= 1;
			if (remaining_enemy_rooms == 0): break;	

	return dungeon;

func _generate_enemy_room(room : Dictionary, current_floor : int) -> void:
	room["room_type"] = "Enemy";
	var enemies : Array[Dictionary] = _get_enemy_layout(current_floor);
	room["enemies"] = enemies;
	
func _get_enemy_layout(current_floor : int) -> Array[Dictionary]:
	# TODO: Change this to randomly selecting enemy group
	current_floor = current_floor;
	var enemy_paths : Array[String] = [
		"res://Entities/Enemies/Bat.tscn",
		"res://Entities/Enemies/Spike.tscn"
	];
	var enemy_layout : Array[Dictionary] = [];
	for enemy_path in enemy_paths:
		var layout : Dictionary = { "node_path" : enemy_path };
		layout.position = Vector2(640, 360) / 2 + Vector2(randi_range(-192, 192), randi_range(-36, 36));
		layout.alive = true;
		enemy_layout.push_back(layout);
	return enemy_layout;
