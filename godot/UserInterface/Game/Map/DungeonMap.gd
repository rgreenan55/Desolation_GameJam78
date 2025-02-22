extends Node2D

signal close_map;

@onready var rooms: Node2D = $Rooms
@onready var hallways: Node2D = $Hallways

const MAP_SCALE : float = 64;

var current_position : Vector2 = Vector2.ZERO;

func _ready() -> void:
	DungeonManager.connect("dungeon_floor_generated", draw_map);
	draw_map();

func draw_map() -> void:
	var dungeon = DungeonManager.dungeon_floor;
	
	for room in rooms.get_children(): room.queue_free();
	for hallway in hallways.get_children(): hallway.queue_free();
	
	if (dungeon == null): return;
	
	for room_pos in dungeon.keys():
		var room : Sprite2D = Sprite2D.new();
		room.texture = get_node("RoomBase").texture;
		room.position = room_pos * MAP_SCALE;
		if (room_pos == Vector2.ZERO): room.modulate = Color.GREEN;
		if (dungeon[room_pos]["room_type"] == "Boss"): room.modulate = Color.RED;
		if (dungeon[room_pos]["room_type"] == "Enemy"): room.modulate = Color.ORANGE;
		if (dungeon[room_pos]["room_type"] == "Chest"): room.modulate = Color.PURPLE;
		if (dungeon[room_pos]["room_type"] == "Key"): room.modulate = Color.BLUE;
		rooms.add_child(room);
		
		var connections : Dictionary = dungeon[room_pos]["room"].connections
		for connection : Vector2 in connections:
			var hallway : Line2D = Line2D.new();
			hallway.add_point(room.position);
			hallway.add_point(room.position + connection * MAP_SCALE);
			hallway.width = MAP_SCALE / 16;
			hallway.default_color = Color.GRAY;
			hallways.add_child(hallway)
	
func get_current_position() -> Vector2:
	return current_position;

func _on_close_button_pressed() -> void:
	close_map.emit();
