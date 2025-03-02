extends Control

signal close_settings_menu;

var settings : UserSettings;

@onready var exit_button: Button = $ExitButton

# Gameplay

# Video
@onready var window_mode_select: OptionButton = %WindowModeSelect
@onready var resolution_select: OptionButton = %ResolutionSelect
@onready var vsync_check: CheckButton = %VsyncCheck

# Audio
@onready var master_volume_slider : HSlider = %MasterVolume
@onready var effect_volume_slider : HSlider = %EffectVolume
@onready var music_volume_slider : HSlider = %MusicVolume

# Load Settings
func _ready() -> void:
	exit_button.connect("pressed", close_settings_menu.emit);
	settings = UserSettings.load_or_create();
	resolution_select.disabled = false if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED else true;

	# Gameplay
	## Nothing

	# Controls
	

	# Video
	var WINDOW_MODES : Array[String] = SettingsManager.get_window_modes();
	for window_mode in WINDOW_MODES: window_mode_select.add_item(window_mode);
	window_mode_select.select(WINDOW_MODES.find(settings.window_mode));
	var RESOLUTIONS : Dictionary = SettingsManager.get_resolutions();
	for resolution in RESOLUTIONS: resolution_select.add_item(resolution);
	resolution_select.select(RESOLUTIONS.values().find(settings.resolution));
	vsync_check.set_pressed_no_signal(settings.vsync);

	# Sound
	master_volume_slider.value = settings.master_volume * 100;
	effect_volume_slider.value = settings.effect_volume * 100;
	music_volume_slider.value = settings.music_volume * 100;

#region Video
func _on_window_mode_selected(index : int) -> void:
	settings.window_mode = SettingsManager.apply_window_mode(index);
	resolution_select.disabled = false if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED else true;
	settings.save();

func _on_resolution_selected(index: int) -> void:
	settings.resolution = SettingsManager.apply_resolution(index);
	settings.save();

func _on_vsync_check_toggled(toggled_on: bool) -> void:
	settings.vsync = SettingsManager.apply_vsync(toggled_on);
	settings.save();

func _on_vsync_gui_input(event: InputEvent) -> void:
	if (event.is_action("UI_Select") && event.is_pressed()):
		vsync_check.grab_focus();
		vsync_check.set_pressed_no_signal(!vsync_check.button_pressed);

#endregion

#region Audio
func _on_master_volume_value_changed(value: float) -> void:
	settings.master_volume = value / 100.0;
	settings.save();

func _on_effect_volume_value_changed(value: float) -> void:
	settings.effect_volume = value / 100.0;
	settings.save();

func _on_music_volume_value_changed(value: float) -> void:
	settings.music_volume = value / 100.0;
	settings.save();

#endregion
