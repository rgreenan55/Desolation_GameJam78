extends Node2D

func _ready() -> void:
	var x = DungeonGenerator.new();
	var t = x.generate();
	
	for r : Vector2 in t:
		var room : Room = t[r];
		for direction : Vector2 in room.connections:
			if (room.connections[direction] != null):
				var l : Line2D = Line2D.new();
				if (r == Vector2(0, 0) || r+direction == Vector2(0,0)): l.default_color = Color.RED;
				l.width = 2;
				l.add_point(r*50)
				l.add_point((r+direction)*50);
				add_child(l);
	
