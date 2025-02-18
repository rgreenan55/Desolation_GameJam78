extends Resource

enum MimicType { Attack, Defence, Special };
@export var type : MimicType;

func apply_modification(user : Entity, target : Entity) -> void:
	pass;
