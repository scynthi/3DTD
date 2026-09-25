class_name Nexus extends CSGBox3D

func _init() -> void:
	global.nexus = self
	


func _on_health_handler_health_drained() -> void:
	queue_free()
