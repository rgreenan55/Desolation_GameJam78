extends Node

const DUNGEON = preload("res://Stages/Dungeon/Dungeon.tscn")

var current_floor : int = 0;

# Dungeon Generation
# -----------------------------------------------------------
signal dungeon_floor_generated;

@onready var dungeon_generator : DungeonGenerator = DungeonGenerator.new();
@export var dungeon_floor : Dictionary;
@export var room_position : Vector2;

func _ready() -> void:
	generate_dungeon_floor();

func generate_dungeon_floor() -> void:
	dungeon_floor = dungeon_generator.generate(current_floor);
	room_position = Vector2.ZERO;
	dungeon_floor_generated.emit();

func move_to_next_floor() -> void:
	current_floor += 1;
	get_tree().change_scene_to_packed(DUNGEON)

func move_to_room(direction : Vector2) -> void:
	room_position += direction;

func get_current_room() -> Dictionary:
	return dungeon_floor[room_position]
	
# Dungeon Game Handler
# -----------------------------------------------------------

@warning_ignore("unused_signal")
signal trigger_transition(direction);

@export var player : Player;
@export var fairy : Fairy;
@export var enemies : Array[Enemy] = [];

signal enemy_added(enemy : Enemy);

func add_enemy(enemy : Enemy) -> void:
	enemies.push_back(enemy);
	enemy_added.emit(enemy);
	
