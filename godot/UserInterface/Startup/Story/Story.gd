extends Control

const OVERWORLD = preload("res://Stages/Overworld/Overworld.tscn");
@onready var story_text: Label = $MarginContainer/StoryText

func _ready() -> void:
	await create_tween().tween_interval(2).finished;
	await set_text("Wake up...");
	await create_tween().tween_interval(2).finished;
	set_text("");
	await create_tween().tween_interval(2).finished;
	await set_text("Wake up!");
	await create_tween().tween_interval(2).finished;
	set_text("...");
	await create_tween().tween_interval(1).finished;
	set_text("");
	await create_tween().tween_property(get_node("Black"), "modulate:a", 0, 2).finished;
	await set_text("I'm sorry, I was too late...");
	await create_tween().tween_interval(4).finished;
	await set_text("Don't worry, I can turn you back.");
	await create_tween().tween_interval(4).finished;
	await set_text("I'll just... need some help");
	await create_tween().tween_interval(4).finished;
	await set_text("Go to the caves to the east...");
	await create_tween().tween_interval(4).finished;
	await set_text("That's where we'll begin.");
	await create_tween().tween_interval(4).finished;
	to_world();
	

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("Interact")):
		to_world();

func set_text(text : String) -> void:
	story_text.modulate.a = 0;
	story_text.text = text;
	await create_tween().tween_property(story_text, "modulate:a", 1, 1).finished;
	

func to_world() -> void:
	get_tree().change_scene_to_packed(OVERWORLD);
