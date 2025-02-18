class_name Player extends Entity

signal mimic_enemy(enemy : Enemy);

# Nodes
@onready var sprite: Sprite2D = $Sprite

func _process(_delta: float) -> void:
	handle_sprite();
	
func handle_sprite() -> void:
	if (velocity.x < 0): sprite.flip_h = true;
	if (velocity.x > 0): sprite.flip_h = false;

# Combat Actions
func attack(target : Enemy) -> void:
	target.take_damage(self, attack_damage);

func defend() -> void:
	current_defence += base_defence;

func special(target : Entity) -> void:
	pass;
	
func mimic(target : Enemy) -> void:
	mimic_enemy.emit(target);


# Game Actions
func entity_death() -> void:
	print("Player Died");
