extends Control

@onready var dungeon_map: Node2D = $MapContainer/MapViewportContainer/MapViewport/DungeonMap
@onready var map_button: Button = $ButtonContainer/ButtonConatiner/MapButton
@onready var map_container: MarginContainer = $MapContainer

func _ready() -> void:
	dungeon_map.connect("close_map", _on_map_close);
	CombatManager.initate_combat.connect(_enter_combat);
	CombatManager.finish_combat.connect(_exit_combat);

func _enter_combat() -> void:
	self.visible = false;
	_on_map_close()
	
func _exit_combat() -> void:
	self.visible = true;

func _on_map_close() -> void:
	var tween : Tween = self.create_tween();
	tween.tween_property(map_container, "position:x", 640 + map_container.size.x, 0.5);
	await tween.finished;
	map_button.visible = true;
	map_container.visible = false;

func _on_map_button_pressed() -> void:
	var tween : Tween = self.create_tween();
	map_container.visible = true;
	map_button.visible = false;
	tween.tween_property(map_container, "position:x", 640 - map_container.size.x, 0.5)
