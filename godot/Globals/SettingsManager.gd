extends Node

const WINDOW_MODES : Array[String] = [
	"Fullscreen",
	#"Borderless", # Does work?
	"Windowed",
];

const RESOLUTIONS : Dictionary = {
	"7680 x 4320" : Vector2i(7680, 4320),
	"3840 x 2160" : Vector2i(3840, 2160),
	"2560 x 1440" : Vector2i(2560, 1440),
	"1920 x 1080" : Vector2i(1920, 1080),
	"1280 x 720" : Vector2i(1280, 720),
	"854 x 480" : Vector2i(854, 480),
	"640 x 360" : Vector2i(640, 360),
};

const MASTER_AUDIO_BUS : int = 0;
const EFFECTS_AUDIO_BUS : int = 1;
const MUSIC_AUDIO_BUS : int = 2;

func _ready() -> void:
	_apply_settings();

func _apply_settings() -> void:
	var settings : UserSettings = UserSettings.load_or_create();
	# Video
	apply_window_mode(WINDOW_MODES.find(settings.window_mode));
	apply_resolution(RESOLUTIONS.values().find(settings.resolution));
	apply_vsync(settings.vsync);
	# Audio
	apply_master_audio(settings.master_volume);
	apply_effect_audio(settings.effect_volume);
	apply_music_audio(settings.music_volume);

#region Video
func get_window_modes() -> Array[String]: return WINDOW_MODES;
func get_resolutions() -> Dictionary: return RESOLUTIONS;

func apply_window_mode(index : int) -> String:
	var value = WINDOW_MODES[index];
	match value:
		"Fullscreen": DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN);
		"Borderless": DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN);
		"Windowed": DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);
	return value;

func apply_resolution(index : int) -> Vector2i:
	DisplayServer.window_set_size(RESOLUTIONS.values()[index]);
	if (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED):
		get_window().move_to_center();
	return RESOLUTIONS.values()[index];

func apply_vsync(applied : bool) -> bool:
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if applied else DisplayServer.VSYNC_DISABLED)
	return applied;
#endregion

#region Audio
func apply_master_audio(volume_percent : float) -> void:
	AudioServer.set_bus_volume_db(MASTER_AUDIO_BUS, linear_to_db(volume_percent));

func apply_effect_audio(volume_percent : float) -> void:
	AudioServer.set_bus_volume_db(EFFECTS_AUDIO_BUS, linear_to_db(volume_percent));

func apply_music_audio(volume_percent : float) -> void:
	AudioServer.set_bus_volume_db(MUSIC_AUDIO_BUS, linear_to_db(volume_percent));
#endregion
