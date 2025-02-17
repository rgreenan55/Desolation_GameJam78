@icon("res://addons/StateMachine/Assets/StateMachineIcon.svg")
@tool class_name StateMachine extends Node

# DO NOT EDIT THIS SCRIPT

var states : Dictionary = {};
@export var current_state : State :
	set(value):
		current_state = value;
		update_configuration_warnings();

@export var parent : CharacterBody2D;
@export var animation_player : AnimationPlayer;

func _ready() -> void:
	parent = get_parent();
	animation_player = get_parent().get_node_or_null("AnimationPlayer");
	update_configuration_warnings();
	update_state_list();
	if (Engine.is_editor_hint()):
		child_entered_tree.connect(state_added);
		child_exiting_tree.connect(state_removed);
	else: current_state.Enter();

# Trigger State Processes
func _process(delta: float) -> void:
	if (Engine.is_editor_hint()): return;
	current_state.Process(delta);
func _physics_process(delta: float) -> void:
	if (Engine.is_editor_hint()): return;
	current_state.Physics_Process(delta);
func _unhandled_input(event: InputEvent) -> void:
	if (Engine.is_editor_hint()): return;
	current_state.Handle_Input(event);

# Handle State Management
func state_added(state : Node) -> void:
	if (state is State): update_state_list();
	else: update_configuration_warnings();
func state_removed(state : Node) -> void:
	if (state is State):
		if (state == current_state):
			current_state = null;
		states.erase(state.name);
		update_configuration_warnings();
func update_state_list() -> void:
	states = {};
	for state : Variant in get_children():
		if (!state is State): continue;
		states[state.name] = state;
		state.parent = parent;
		state.animations = animation_player;
		if(!state.is_connected("transitioned", on_child_transitioned)):
			state.connect("transitioned", on_child_transitioned);
		if(!state.is_connected("renamed", update_state_list)):
			state.connect("renamed", update_state_list); # Renamed Emitting Twice?
	# Default to First State if Default not Provided
	if (current_state == null && !states.is_empty()):
		current_state = states.values()[0];

# Handle State Transitions
func on_child_transitioned(new_state_name : StringName) -> void:
	var new_state = states.get(new_state_name);
	if (new_state == current_state): return;
	if (new_state != null):
		current_state.Exit();
		new_state.Enter();
		current_state = new_state;
	else:
		push_warning(self.name, ": called transition on state that does not exist");

# Configuration Warnings
func _get_configuration_warnings() -> PackedStringArray:
	var warnings : PackedStringArray = [];
	if (current_state == null):
		warnings.append("No default state provided.");
	if (get_child_count() < 1):
		warnings.append("No states in machine.");
	if (get_children().any(func(child): !(child is State))):
		warnings.append("Non state child in machine.");
	if (animation_player == null):
		warnings.append("No animation player in parent tree.");
	return warnings;
