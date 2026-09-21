extends Control


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	scene_loader.load_map(scene_loader.map_list.default_map)
