extends Control

func _on_check_button_toggled(toggled_on: bool) -> void:
	global.infinite_fragment = toggled_on
	

func _on_play_pressed() -> void:
	scene_loader.load_map(scene_loader.map_list.default_map)
	

func _on_exit_pressed() -> void:
	get_tree().quit()
	

func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 3 * value)
	 
