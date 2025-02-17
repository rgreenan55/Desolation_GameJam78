extends Camera2D

# Zoom Values
#const MIN_ZOOM : float = 0.5;
#const MAX_ZOOM : float = 2;
#const ZOOM_INCREMENT : float = 0.1;
#const ZOOM_RATE : float = 8.0;
#var _target_zoom : float = 1;

# Parent
@onready var dungeon_map: Node2D = $"..";

#func _physics_process(delta: float) -> void:
	#zoom = lerp(zoom, _target_zoom * Vector2.ONE, ZOOM_RATE * delta);
	#set_physics_process(not is_equal_approx(zoom.x, _target_zoom));

func _process(_delta: float) -> void:
	var current_position : Vector2 = dungeon_map.get_current_position();
	var screen_size : Vector2 = get_viewport_rect().size / 2 / zoom;
	
	# Keeps Current Room in View
	position.x = clamp(position.x, current_position.x-screen_size.x, current_position.x+screen_size.x);
	position.y = clamp(position.y, current_position.y-screen_size.y, current_position.y+screen_size.y);
	
func center_on_room() -> void:
	position = dungeon_map.get_current_position();

func _unhandled_input(event: InputEvent) -> void:
	if (event is InputEventMouseMotion && event.button_mask == MOUSE_BUTTON_MASK_LEFT):
		position -= event.relative / zoom
	#if (event is InputEventMouseButton && event.is_pressed()):
		#if (event.button_index == MOUSE_BUTTON_WHEEL_UP): zoom_in()
		#if (event.button_index == MOUSE_BUTTON_WHEEL_DOWN): zoom_out();
		
#func zoom_in() -> void:
	#_target_zoom = min(_target_zoom + ZOOM_INCREMENT, MAX_ZOOM);
	#set_physics_process(true);
#func zoom_out() -> void:
	#_target_zoom = max(_target_zoom - ZOOM_INCREMENT, MIN_ZOOM);
	#set_physics_process(true);
