class_name EntityCard extends MarginContainer

# Utility
@onready var name_label: Label = %NameLabel
@onready var health_ui: ProgressBar = %HealthUI
@onready var health_label: Label = %HealthLabel
@onready var defence_label: Label = %DefenceLabel

func connect_to_entity(entity : Entity):
	# Wait until ready
	if (!self.is_node_ready()): await self.ready;
	
	# Update Basis
	name_label.text = entity.entity_name;
	update_health(entity.current_health, entity.total_health);
	update_defence(entity.current_defence);
	
	# Signals
	entity.health_changed.connect(update_health);
	entity.defence_changed.connect(update_defence);
	entity.combat_card = self;
	
func update_health(health : int, total : int) -> void:
	var percentage : float = float(health) / float(total) * 100;
	health_label.text = str(health);
	var tween : Tween = create_tween();
	tween.tween_property(health_ui, "value", percentage, 0.25);
	if (percentage == 0): pass; # Play Animation
	
func update_defence(defence : int) -> void:
	defence_label.text = str(defence);
	
func remove_card() -> void:
	print("Removing");
	var tween : Tween = create_tween()
	tween.tween_property(self.material, "shader_parameter/DissolveValue", 1, 2);
	await tween.finished;
	self.queue_free();
