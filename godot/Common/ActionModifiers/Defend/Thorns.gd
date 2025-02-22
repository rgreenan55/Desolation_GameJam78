class_name Thorns extends DefendModifier

#func _init() -> void:
	#icon = ""

func apply_modification(value : int, user : Entity, target : Entity) -> int:
	var thorns_damage : int = min(value, user.current_defence) / 2;
	target.take_flat_damage(user, thorns_damage);
	return value;

func get_description() -> String:
	return "Thorns : return 50% of shield damage as health damage."
