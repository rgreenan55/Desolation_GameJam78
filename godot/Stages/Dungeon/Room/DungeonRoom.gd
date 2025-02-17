class_name DungeonRoom extends Node2D

@onready var enemy_storage: Node2D = $EnemyStorage

func _ready() -> void:
	_setup_room(DungeonManager.get_current_room());
	CombatManager.connect("initate_combat", _initate_combat);

#region Room Setup
func _setup_room(room_data : Dictionary) -> void:
	var room_connections = room_data.room.connections;
	_handle_doors(room_connections);
	
	var room_type : String = room_data.room_type;
	match (room_type):
		"Enemy": _handle_enemy_spawns(room_data.enemies);
		"Chest": pass;
		"Boss": pass;
		
func _handle_enemy_spawns(enemies : Array[Dictionary]) -> void:
	for enemy_data in enemies:
		var enemy : Enemy = load(enemy_data.node_path).instantiate();
		enemy.position = enemy_data.position;
		enemy_storage.add_child(enemy);
#endregion

#region Combat Stuff
@onready var player_position: Node2D = $FightPositions/PlayerPosition
@onready var enemy_positions : Array[Node2D] = [
	$FightPositions/EnemyPosition1,
	$FightPositions/EnemyPosition2,
	$FightPositions/EnemyPosition3,
	$FightPositions/EnemyPosition4
]

func _initate_combat() -> void:
	var tween : Tween = create_tween();
	tween.set_parallel(true);
	tween.tween_property(get_node("Player"), "position", player_position.position, 1);
	var enemy_nodes : Array[Node] = enemy_storage.get_children();
	for i in range(enemy_nodes.size()):
		tween.tween_property(enemy_nodes[i], "position", enemy_positions[i].position, 1);
	CombatManager.combat_is_ready();
	
#endregion

#region Door Stuff
@onready var north_wall: Sprite2D = $Textures/NorthWall
@onready var east_wall: Sprite2D = $Textures/EastWall
@onready var south_wall: Sprite2D = $Textures/SouthWall
@onready var west_wall: Sprite2D = $Textures/WestWall

@onready var north_door: RoomDoor = $Doors/NorthDoor
@onready var east_door: RoomDoor = $Doors/EastDoor
@onready var south_door: RoomDoor = $Doors/SouthDoor
@onready var west_door: RoomDoor = $Doors/WestDoor

func _handle_doors(connections : Dictionary) -> void:
	# Checks
	var north : bool = connections.has(Vector2.UP);
	var east : bool = connections.has(Vector2.RIGHT);
	var south : bool = connections.has(Vector2.DOWN);
	var west : bool = connections.has(Vector2.LEFT);
	
	# Sprites
	north_wall.frame = 0 if north else 1;
	east_wall.frame = 0 if east else 1;	
	south_wall.frame = 0 if south else 1;	
	west_wall.frame = 0 if west else 1;
	
	# Door Collisions
	north_door.get_node("CollisionShape2D").call_deferred("set_disabled", !north);
	east_door.get_node("CollisionShape2D").call_deferred("set_disabled", !east);
	south_door.get_node("CollisionShape2D").call_deferred("set_disabled", !south);
	west_door.get_node("CollisionShape2D").call_deferred("set_disabled", !west);
		
#endregion
