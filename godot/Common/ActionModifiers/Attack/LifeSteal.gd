class_name LifeSteal extends AttackModifier

func apply_modification(value : int, user : Entity, target : Entity) -> int:
	var damage : int = target.calculate_damage(value);
	if (damage > 0): user.heal_damage(floor(damage * 0.20));
	return value;

func get_description() -> String:
	return "Lifesteal : Heal 20% damage dealt."
