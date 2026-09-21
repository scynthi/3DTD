class_name HurtboxComponent extends Area3D

@export var health_handler : HealthHandler

func _on_area_entered(area: Area3D) -> void:
	if area is HitboxComponent:
		health_handler.damage(area.damage)
