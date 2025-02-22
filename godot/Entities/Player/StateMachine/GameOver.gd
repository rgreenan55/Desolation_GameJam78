extends State

@onready var player_utility: Control = $"../../PlayerUIContainer/PlayerUtility"

func Enter() -> void:
	process_mode = PROCESS_MODE_INHERIT;
	player_utility.display_game_over();
