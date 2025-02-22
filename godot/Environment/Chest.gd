class_name Chest extends Interactable

@export var ref : Dictionary;

@export var opened : bool = false :
	set(value):
		opened = value;
		ref.opened = opened;
		if (opened): self.modulate = Color.RED;

func _process(_delta: float) -> void:
	interactable_area.get_node("CollisionShape2D").set_deferred("disabled", opened);

func interact() -> void:
	opened = true;
	GameManager.gold += randi_range(10, 25);
	self.modulate = Color.RED;
