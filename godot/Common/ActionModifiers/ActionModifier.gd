class_name ActionModifier extends Resource

@export var icon : Texture;

@warning_ignore("unused_parameter")
func apply_modification(value : int, user : Entity, target : Entity) -> int:
	return value;
	
func get_description() -> String:
	return "";
