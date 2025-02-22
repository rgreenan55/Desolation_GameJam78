class_name DungeonRoom extends Node2D

@onready var enemy_storage: Node2D = $EnemyStorage;
@onready var chest_position: Node2D = $ChestPosition

@onready var player_combat_position: Node2D = $CombatPositions/PlayerPosition;
@onready var enemy_combat_positions : Array[Node2D] = [
	$CombatPositions/EnemyPosition1,
	$CombatPositions/EnemyPosition2,
	$CombatPositions/EnemyPosition3,
	$CombatPositions/EnemyPosition4
];
@onready var boss_position: Node2D = $CombatPositions/BossPosition

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
		"Chest": _handle_chest_spawn(room_data.chest);
		"Boss": _handle_boss_spawn(room_data.enemy_data);
		
func _handle_enemy_spawns(enemies : Array[Dictionary]) -> void:
	for i in range(enemies.size()):
		var enemy_data : Dictionary = enemies[i];
		if (enemy_data.alive == false): continue;
		var enemy : Enemy = load(enemy_data.node_path).instantiate();
		enemy.ref = enemy_data;
		DungeonManager.add_enemy(enemy);
		enemy.position = enemy_data.position;
		enemy.combat_position = enemy_combat_positions[i].position;
		enemy_storage.add_child(enemy);
		
func _handle_chest_spawn(chest_data : Dictionary) -> void:
	var chest : Chest = load("res://Environment/Chest.tscn").instantiate();
	chest.position = chest_position.position;
	chest.opened = chest_data.opened;
	chest.ref = chest_data;
	add_child(chest);
	
func _handle_boss_spawn(boss_data) -> void:
	var boss : SlimeBoss = load("res://Entities/Enemies/SlimeBoss.tscn").instantiate();
	boss.ref = boss_data;
	DungeonManager.add_enemy(boss);
	boss.combat_position = boss_position.position;
	boss.position = boss_data.position;
	enemy_storage.add_child(boss);
#endregion

#region Combat Stuff
func _initate_combat() -> void:
	# Player
	var player : Player = DungeonManager.player
	player.combat_position = player_combat_position.position;
	player.move_to_combat_position();
	# Enemies
	var enemy_nodes : Array[Node] = enemy_storage.get_children();
	for enemy in enemy_nodes: enemy.move_to_combat_position();
	# Initiate Combat
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
