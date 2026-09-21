class_name HealComponent extends Area3D

@export var heal_amount : int = 1
@export var full_heal : bool = false


func _on_body_entered(body: Node3D) -> void:
	if body is HealthHandler:
		if full_heal: body.fullheal()
		else: body.heal(heal_amount)
		
		queue_free()
	
