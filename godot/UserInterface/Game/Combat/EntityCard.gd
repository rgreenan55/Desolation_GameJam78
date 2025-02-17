class_name EntityCard extends MarginContainer

@onready var name_ui : Label = $MarginContainer/HBoxContainer/VBoxContainer/Name
@onready var health_ui : ProgressBar = $MarginContainer/HBoxContainer/VBoxContainer/Health

func connect_to_entity(entity : Entity):
	if (!self.is_node_ready()): await self.ready;
	name_ui.text = entity.entity_name;
	update_health(entity.health, entity.total_health);
	entity.health_changed.connect(update_health);
	
func update_health(health : int, total : int) -> void:
	var percentage : float = float(health) / float(total) * 100;
	var tween : Tween = create_tween();
	tween.tween_property(health_ui, "value", percentage, 0.25);
	if (percentage == 0): pass; # Play Animation
	
