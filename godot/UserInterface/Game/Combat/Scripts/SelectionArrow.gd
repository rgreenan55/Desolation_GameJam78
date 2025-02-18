extends Sprite2D

func _process(_delta: float) -> void:
	var selected_unit : Entity = CombatManager.get_selected_unit();
	if (selected_unit):
		self.global_position = selected_unit.get_global_transform_with_canvas().origin;
		self.visible = true;
	else:
		self.visible = false;

var floating_position = Vector2.ZERO;
var time : int = 0;
func _physics_process(_delta: float) -> void:
	time += 1;
	self.offset = Vector2(
		self.offset.x,
		self.offset.y + sin(time * 0.1) * 0.5
	);
	
