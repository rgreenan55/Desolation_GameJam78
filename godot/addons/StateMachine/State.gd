@icon("res://addons/StateMachine/Assets/StateIcon.svg")
class_name State extends Node

# DO NOT EDIT THIS SCRIPT
# VIEW IN INSPECTOR -> BOTTOM -> SCRIPT -> RIGHT CLICK -> EXTEND SCRIPT

signal transitioned(new_state_name : StringName);
@export var parent : CharacterBody2D;
@export var animations : AnimationPlayer

func Enter() -> void:
	process_mode = PROCESS_MODE_INHERIT;

func Exit() -> void:
	process_mode = PROCESS_MODE_DISABLED;

func Process(_delta : float) -> void:
	pass;

func Physics_Process(_delta : float) -> void:
	pass;

func Handle_Input(_event : InputEvent) -> void:
	pass;
