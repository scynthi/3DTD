class_name Nexus extends CSGBox3D

@onready var health_component: HealthComponent = $HealthComponent

func _init() -> void:
	global.nexus = self
	


func _on_health_handler_health_drained() -> void:
	queue_free()
	
