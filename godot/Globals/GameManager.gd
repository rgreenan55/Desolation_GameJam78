extends Node

signal gold_count_changed(changed_by : int, new_total : int);
signal souls_count_changed(changed_by : int, new_total : int);

@export var shop_restored : bool = false;

# Upgrades
@export var attack : int = 0;
@export var defence : int = 0;
@export var health : int = 0;

const MAX_COUNT : int = 999;
const MIN_COUNT : int = 0;

@export var gold : int = 0 :
	set(value):
		var diff = value - gold;
		if (diff == 0): return;
		gold = clamp(value, MIN_COUNT, MAX_COUNT);
		print(value, " ", gold);
		gold_count_changed.emit(diff, gold);
		
@export var souls : int = 0 :
	set(value):
		var diff = value - souls;
		if (diff == 0): return;
		souls = clamp(value, MIN_COUNT, MAX_COUNT);
		print(value, " ", souls);
		souls_count_changed.emit(diff, souls);
