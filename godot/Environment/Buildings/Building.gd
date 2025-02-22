extends Interactable

@export var restored : bool = false;
@export var restore_soul_cost : int = 5;
@onready var sprite: Sprite2D = $Sprite2D

@onready var shop_ui: CanvasLayer = $ShopUI
@onready var restore_ui: CanvasLayer = $RestoreUI

func _ready() -> void:
	restored = GameManager.shop_restored;
	set_restore_fast(restored);

func set_restore_fast(r : bool) -> void:
	sprite.material.set("shader_parameter/greyscalePerentage", 1 if r else 0);

func restore() -> void:
	restored = true;
	GameManager.shop_restored = true;
	await create_tween().tween_property(sprite.material, "shader_parameter/greyscalePerentage", 1, 1).finished;

func _on_interactable_area_area_entered(area: Area2D) -> void:
	if (area.is_in_group("Player")):
		if (restored): shop_ui.visible = true;
		else: restore_ui.visible = true;
		
func _on_interact_area_area_exited(area: Area2D) -> void:
	if (area.is_in_group("Player")):
		if (restored): shop_ui.visible = false;
		else: restore_ui.visible = false;

func _on_button_pressed() -> void:
	if (GameManager.souls >= 5):
		GameManager.souls -= 5;
		restore_ui.visible = false;
		shop_ui.visible = true;
		restore();
		
