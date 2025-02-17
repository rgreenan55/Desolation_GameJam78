# Heavily Inspired from:  https://github.com/derkork/godot-safe-resource-loader/tree/master
class_name SafeResourceLoader

static func load(path : String, type_hint : String = "", cache_mode : ResourceLoader.CacheMode = ResourceLoader.CacheMode.CACHE_MODE_REUSE) -> Resource:
	# Ensure path is a Resource File
	if (!path.ends_with(".tres")):
		push_error("This resource loader only supports .tres files");
		return null;

	# Seek to only verify external files.
	# Internal Files should be considered safe.
	if (path.begins_with("res://")):
		push_error(
			"This resource loader is intended for loading resources from unsafe origins. " +\
			"Files located within res:// will only slow down loading with no benefit of security"
		);
		return null;

	# Check if the File Exists
	if (!FileAccess.file_exists(path)):
		push_error("File at: " + path + " does not exist or is not accessible.");
		return null;

	# Load the File as Text (prevents execution of scripts)
	var file = FileAccess.open(path, FileAccess.READ);
	var file_as_text = file.get_as_text();
	file.close();

	# Use Regex to find GDScript Resources.
	var regex : RegEx = RegEx.new();
	regex.compile("type\\s*=\\s*\"GDScript\"\\s*");

	# If GDScript is found, Abort.
	if (regex.search(file_as_text) != null):
		push_warning("Resource '" + path + "' contains inline GDScript, file not loaded.");
		return null;

	# Ensure all resources are within res://
	# Format is: [ext_resource type="Script" path="res://safe_resource_loader_example/saved_game.gd" id="1_on72l"]
	# Path should begin with res://
	# Type does not matter as a Resource could contain Resources which contain malicious scripts.
	# Refuse any resource that is not in res://

	var extResourceRegex : RegEx = RegEx.new();
	extResourceRegex.compile("\\[\\s*ext_resource\\s*.*?path\\s*=\\s*\"([^\"]*)\".*?\\]");
	var matches : Array = extResourceRegex.search_all(file_as_text);
	for match in matches:
		var resourcePath : String = match.get_string(1);
		if (!resourcePath.begins_with("res://")):
			push_warning("Resource '" + path + "' contains and ext_resource with a path\n outside res:// (path is ')" + resourcePath + "', file not loaded");
			return null;

	return ResourceLoader.load(path, type_hint, cache_mode);
