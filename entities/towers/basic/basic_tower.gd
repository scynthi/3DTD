class_name BasicTower extends Node3D

@onready var head: Marker3D = $Head
@onready var shoot_timer: Timer = $ShootTimer

const BULLET_SCENE = preload("res://entities/projectiles/bullet.tscn")

var enemy : BasicEnemy = null

func _physics_process(_delta: float) -> void:
	if enemy: head.look_at(enemy.global_position)
	

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		enemy = body
	

func _on_area_3d_body_exited(_body: Node3D) -> void:
	enemy = null
	head.rotation = Vector3.ZERO
	

func _on_shoot_timer_timeout() -> void:
	if enemy:
		var bullet : Bullet = BULLET_SCENE.instantiate()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = head.global_position
		
		var calculated_bullet_transform  : Transform3D = bullet.transform
		calculated_bullet_transform.basis = head.global_transform.basis
		calculated_bullet_transform.origin = head.global_transform.origin
		
		bullet.transform = calculated_bullet_transform
	
