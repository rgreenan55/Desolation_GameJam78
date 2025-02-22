class_name Enemy extends Entity

@export_range(0, 70, 5) var attack_defend_percentage = 35;

@export var ref : Dictionary;

func entity_death() -> void:
	ref.alive = false;
	DungeonManager.remove_enemy(self);
	GameManager.souls += randi_range(1, 3);
	super();
	
func get_enemy_action_decision() -> String:
	var decision : int = randi_range(0, 100);
	if (decision > 70): return "Idle";
	elif (decision > attack_defend_percentage): return "Defend";
	else: return "Attack"

func get_modifier() -> ActionModifier:
	var tween : Tween = create_tween();
	tween.tween_interval(1.20);
	tween.tween_property(get_node("Sprite").material, "shader_parameter/greyscalePerentage", 0, 0.5);
	
	if (attack_modifier): return attack_modifier;
	if (defence_modifier): return defence_modifier;
	if (special_modifier): return special_modifier;
	return null;

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE:
			combat_card.remove_card_instant()
			ref.position = self.position;
