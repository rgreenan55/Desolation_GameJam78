extends CanvasLayer

@onready var health: VBoxContainer = $CenterContainer/VBoxContainer/HBoxContainer/Health
@onready var attack: VBoxContainer = $CenterContainer/VBoxContainer/HBoxContainer/Attack
@onready var defence: VBoxContainer = $CenterContainer/VBoxContainer/HBoxContainer/Defence

func _process(_delta: float) -> void:
	health.get_node("Label").text = "Level: " + str(GameManager.health);
	attack.get_node("Label").text = "Level: " + str(GameManager.attack);
	defence.get_node("Label").text = "Level: " + str(GameManager.defence);
	
func _on_health_button_pressed() -> void:
	if (GameManager.gold >= 10 && GameManager.souls >= 5):
		GameManager.gold -= 10
		GameManager.souls -= 5;
		GameManager.health += 1;

func _on_attack_button_pressed() -> void:
	if (GameManager.gold >= 10 && GameManager.souls >= 5):
		GameManager.gold -= 10
		GameManager.souls -= 5;
		GameManager.attack += 1;

func _on_defence_button_pressed() -> void:
	if (GameManager.gold >= 10 && GameManager.souls >= 5):
		GameManager.gold -= 10
		GameManager.souls -= 5;
		GameManager.defence += 1;
