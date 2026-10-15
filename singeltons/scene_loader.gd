class_name SceneLoader extends Node

const default_map_folder : String = "res://trenchbroom/maps/"
const default_ui_scene_folder : String = "res://ui/"

enum map_list { default_map, win_scene }
var _map_dict : Dictionary[int, String] = {
	map_list.default_map: default_map_folder+"default_map.tscn",
	map_list.win_scene: default_map_folder+"win/win.tscn"
}

enum ui_scenes {loading_screen, death_screen, main_menu }
var _ui_scenes_dict : Dictionary[int, String] = {
	ui_scenes.loading_screen: default_ui_scene_folder+"loading_screen/loading_screen.tscn",
	ui_scenes.death_screen: default_ui_scene_folder+"death_screen/death_screen.tscn",
	ui_scenes.main_menu: default_ui_scene_folder+"Main menu/main_menu_scene.tscn"
}

var is_busy : bool = false
var status : int
var progress : Array[int] = []

var _map : String = ""

func load_map(map_id : int) -> void:
	if is_busy: return
	is_busy = true
	
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	get_tree().change_scene_to_file(_ui_scenes_dict.get(ui_scenes.loading_screen))
	
	_map = _map_dict.get(map_id)
	if !_map: return print("Map with ID "+str(map_id)+" has not been defined in _map_dict.")
	
	ResourceLoader.load_threaded_request(_map)
	

func load_ui_scene(ui_scene_id: int, change_scene: bool = true, pause_enabled : bool = true, pause_timeout : float = 0.0) -> void:
	if is_busy: return
	is_busy = true
	_map = ""
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	var ui_scene : PackedScene = load(_ui_scenes_dict.get(ui_scene_id))
	if !ui_scene_id: return print("UI scene with ID "+str(ui_scene_id)+" has not been defined in _ui_scenes_dict.")
	
	if change_scene:
		get_tree().call_deferred("change_scene_to_packed", ui_scene)
	else:
		get_tree().current_scene.add_child(ui_scene.instantiate())
		if pause_enabled:
			if pause_timeout > 0.0:
				global.player.input_handler.disable_input()
				await get_tree().create_timer(pause_timeout).timeout
			get_tree().paused = true
	is_busy = false
	

func _process(_delta: float) -> void:
	if _map:
		status = ResourceLoader.load_threaded_get_status(_map, progress)
		
		if status == ResourceLoader.THREAD_LOAD_LOADED:
			get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(_map))
			is_busy = false
		
	
