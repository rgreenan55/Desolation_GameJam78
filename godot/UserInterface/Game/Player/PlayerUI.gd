extends MarginContainer

@onready var health: ProgressBar = $Splitter/Health
@onready var gold_label: Label = $Splitter/Resources/GoldContainer/GoldLabel
@onready var souls_label: Label = $Splitter/Resources/SoulsContainer/SoulsLabel
@onready var interact_label: Label = $FreeNodes/InteractLabel

var gold_count : int = GameManager.gold;
var souls_count : int = GameManager.souls;

@onready var player : Player = get_parent().get_parent();

var interact_area : Area2D = null;

func _ready() -> void:
	gold_label.text = str(GameManager.gold);
	souls_label.text = str(GameManager.souls);
	GameManager.gold_count_changed.connect(_update_gold_count);
	GameManager.souls_count_changed.connect(_update_souls_count);
	_update_health(player.current_health, player.total_health);
	player.health_changed.connect(_update_health);

var gold_tween : Tween;
func _update_gold_count(change_by_amount : int, new_total : int) -> void:
	var change_label : Label = gold_label.get_node("ChangeLabel");
	change_label = change_label.duplicate();
	gold_label.add_child(change_label);
	change_label.text = "+" if change_by_amount > 0 else "";
	for character in str(change_by_amount): change_label.text += character;
	create_tween().tween_property(self, "gold_count", new_total, 0.5);
	await create_tween().tween_property(change_label, "modulate:a", 0, 1.0).finished
	change_label.queue_free();
	
var souls_tween : Tween;
func _update_souls_count(change_by_amount : int, new_total : int) -> void:
	var change_label : Label = souls_label.get_node("ChangeLabel");
	change_label = change_label.duplicate();
	souls_label.add_child(change_label);
	change_label.text = "+" if change_by_amount > 0 else "-";
	for character in str(change_by_amount): change_label.text += character;
	create_tween().tween_property(self, "souls_count", new_total, 0.5);
	await create_tween().tween_property(change_label, "modulate:a", 0, 1.0).finished
	change_label.queue_free();

func _update_health(hp : int, total : int) -> void:
	health.value = float(hp) / float(total) * 100;

func _process(_delta: float) -> void:
	health.visible = !CombatManager.in_combat
	interact_label.visible = interact_area != null;
	interact_label.position = Vector2(player.position.x - 50, player.position.y - 48);
	gold_label.text = str(gold_count);
	souls_label.text = str(souls_count);
	
	# JANKY
	if gold_count < 10: gold_label.text = "0" + gold_label.text 
	if gold_count < 100: gold_label.text = "0" + gold_label.text 
	if souls_count < 10: souls_label.text = "0" + souls_label.text 
	if souls_count < 100: souls_label.text = "0" + souls_label.text 
	
func _input(event: InputEvent) -> void:
	if (interact_area && event.is_action_pressed("Interact")):
		interact_area.parent.interact();

func _on_area_detector_area_entered(area: Area2D) -> void:
	if (area.is_in_group("Interactable")):
		interact_area = area;

func _on_area_detector_area_exited(area: Area2D) -> void:
	if (area.is_in_group("Interactable")):
		interact_area = null;
