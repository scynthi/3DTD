class_name Bullet extends CharacterBody3D

@export var speed : float = 50.0

func _physics_process(_delta: float) -> void:
	velocity = transform.basis * Vector3(0, 0, speed * -1.0)
	move_and_slide()
	

func _on_timer_timeout() -> void:
	queue_free()
	

func _on_hurtbox_component_area_entered(_area: Area3D) -> void:
	queue_free()
	
