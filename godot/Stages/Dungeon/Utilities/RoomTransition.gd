extends Node

@export var room_template : PackedScene;

# Scene Root
@onready var dungeon : Node2D = $"../..";

# Room Management
@onready var player : CharacterBody2D = $"../../DungeonRoom/Player";
@onready var fairy: Fairy = $"../../DungeonRoom/Fairy";
@onready var current_room : DungeonRoom = $"../../DungeonRoom";
@onready var next_room : DungeonRoom = null;

# Transition Values
@onready var transition_speed : float = 0.50;
@onready var room_size : Vector2 = dungeon.get_viewport_rect().size;

func _ready() -> void:
	DungeonManager.connect("trigger_transition", _on_room_transition);
	DungeonManager.player = player;
	DungeonManager.fairy = fairy;
	
func _on_room_transition(compass_direction : int) -> void:
	var direction : Vector2 = RoomDoor.get_direction_vector(compass_direction);
	
	# Lock Movement
	player.state_machine.on_child_transitioned(&"Locked");
	for enemy in DungeonManager.enemies:
		enemy.state_machine.on_child_transitioned(&"Locked");
	DungeonManager.enemies.clear();
	
	# Update Global Room Position
	DungeonManager.move_to_room(direction);
	
	# Create New Room
	next_room = room_template.instantiate();
	next_room.position = room_size * direction
	dungeon.call_deferred("add_child", next_room);
	
	# Get New Door Position + Maintain Other Axis
	var player_pos : Vector2 = (room_size / 2) + (-direction * room_size/2 * Vector2(0.75, 0.50));
	player_pos = abs(direction) * player_pos + abs(Vector2(direction.y, direction.x)) * player.position;
	
	# Move Player & Fairy to Next Room
	player.reparent(next_room);
	fairy.reparent(next_room, true);
	
	# Set Player Position
	player.position = player_pos;
	
	# Setup Room Transition Tweens
	var tween : Tween = create_tween();	
	tween.set_parallel(true);
	tween.set_pause_mode(Tween.TWEEN_PAUSE_STOP)
	tween.tween_property(next_room, "position", current_room.position, transition_speed);
	tween.tween_property(current_room, "position", current_room.position - room_size * direction, transition_speed);
	await tween.finished;
	
	# Free Movement
	player.state_machine.on_child_transitioned(&"Free");
	for enemy in DungeonManager.enemies:
		enemy.state_machine.on_child_transitioned(&"Free");
		
	# Cleanup
	current_room.queue_free();
	current_room = next_room;
