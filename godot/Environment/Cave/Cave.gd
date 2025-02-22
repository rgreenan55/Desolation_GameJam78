extends StaticBody2D

const DUNGEON = preload("res://Stages/Dungeon/Dungeon.tscn")

func _on_cave_enter_area_body_entered(body: Node2D) -> void:
	if (body.is_in_group("Player")):
		var player : Player = body;
		player.state_machine.on_child_transitioned(&"Locked");
		await player.get_node("PlayerUIContainer/PlayerUtility").fade_to_black();
		DungeonManager.move_to_next_floor();
