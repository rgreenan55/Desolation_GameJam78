class_name RoomDoor extends Area2D

enum Compass { North, East, South, West }
@export var transition_direction : Compass;

func _on_body_entered(body: Node2D) -> void:
	if (body.is_in_group("Player")):
		DungeonManager.trigger_transition.emit(transition_direction);
		for door in get_parent().get_children():
			door.get_child(0).call_deferred("set_disabled", true);

static func get_direction_vector(compass_direction) -> Vector2:
	match(compass_direction):
		Compass.North: return Vector2(0, -1);
		Compass.East: return Vector2(1, 0);
		Compass.South: return Vector2(0, 1);
		Compass.West: return Vector2(-1, 0);
	return Vector2.ZERO;
		
