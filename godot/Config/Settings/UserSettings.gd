class_name UserSettings extends Resource

const SETTINGS_PATH = "user://user_settings.tres";

# Gameplay


# Video
@export_enum("Fullscreen", "Borderless", "Windowed") var window_mode : String = "Borderless"
@export var resolution : Vector2i = Vector2i(1920, 1080);
@export var vsync : bool = false;
@export_range(0, INF, 1) var max_fps : int = 0;

# Audio
@export_range(0, 1, 0.05) var master_volume : float = 0.5;
@export_range(0, 1, 0.05) var effect_volume : float = 0.5;
@export_range(0, 1, 0.05) var music_volume : float = 0.5;

# Controls


func save() -> void:
	ResourceSaver.save(self, SETTINGS_PATH);

static func load_or_create() -> UserSettings:
	if (!FileAccess.file_exists(SETTINGS_PATH)): return UserSettings.new();
	return SafeResourceLoader.load(SETTINGS_PATH) as UserSettings;
