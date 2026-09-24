class_name BasicTower extends Node3D

@onready var head: Marker3D = $Head

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		head.look_at(body.position)
		
	

func _on_area_3d_body_exited(_body: Node3D) -> void:
	head.rotation = Vector3.ZERO
	
