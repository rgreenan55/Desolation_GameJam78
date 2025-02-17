extends CanvasLayer

const SETTINGS_MENU = preload("res://UserInterface/Menus/Settings/SettingsMenu.tscn")

enum MenuOpen { Closed, Paused, Settings };
var menu_open : MenuOpen = MenuOpen.Closed;
@onready var pause_menu: Control = $PauseMenu

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("Pause")):
		match menu_open:
			MenuOpen.Closed: _open_pause_menu();
			MenuOpen.Paused: _close_pause_menu();
			MenuOpen.Settings: _close_settings_menu();

#region Menu Handlers
func _open_pause_menu() -> void:
	menu_open = MenuOpen.Paused;
	pause_menu.visible = true;
	get_tree().paused = true;

func _close_pause_menu() -> void:
	menu_open = MenuOpen.Closed;
	pause_menu.visible = false;
	get_tree().paused = false;

func _close_settings_menu() -> void:
	menu_open = MenuOpen.Paused;
	if (has_node("SettingsMenu")):
		get_node("SettingsMenu").queue_free();
	pause_menu.visible = true;
#endregion

#region Button Handlers
func _on_continue_button_pressed() -> void:
	menu_open = MenuOpen.Closed;
	pause_menu.visible = false;
	get_tree().paused = false;

func _on_settings_button_pressed() -> void:
	menu_open = MenuOpen.Settings;
	pause_menu.visible = false;
	var settings_menu = SETTINGS_MENU.instantiate()
	settings_menu.connect("close_settings_menu", _close_settings_menu);
	add_child(settings_menu);

func _on_exit_button_pressed() -> void:
	get_tree().quit();
#endregion
