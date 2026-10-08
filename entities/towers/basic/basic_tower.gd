class_name BasicTower extends Tower

const BULLET_SCENE = preload("res://entities/projectiles/bullet.tscn")

@onready var health_component : HealthComponent = $HealthHandler/HealthComponent
@onready var head : Marker3D = $Head
@onready var shoot_timer : Timer = $ShootTimer
@onready var detection_range : float = $DetectionArea/DetectionCollisionShape3D.shape.size.z
@onready var detection_range_collision_shape : CollisionShape3D = $DetectionArea/DetectionCollisionShape3D


@export var default_stats : TowerData

var enemy : Enemy = null
var damage : float = 1


func update_damage(value : float):
	damage = default_stats.damage + value
	

func update_detection_range(value : float):
	detection_range = default_stats.detection_range + value
	

func update_attack_speed(value : float):
	shoot_timer.wait_time = clampf(value, 0.2, 1)
	

func update_health(value : float):
	health_component.max_health =default_stats.health + value
	

func find_new_target(delta : float) -> void:
	if enemy: return
	
	detection_range_collision_shape.shape.size = lerp(detection_range_collision_shape.shape.size, Vector3(global.tower_data.detection_range + default_stats.detection_range, 1.983, global.tower_data.detection_range + default_stats.detection_range), delta * 10)
	

func _physics_process(delta: float) -> void:
	if enemy: head.look_at(enemy.global_position + Vector3(0, 0.2, 0))
	find_new_target(delta)
	

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		enemy = body
		if enemy.health_handler.health_drained.is_connected(reset_target): return
		enemy.health_handler.health_drained.connect(reset_target)
		
	

func _on_area_3d_body_exited(_body: Node3D) -> void:
	reset_target()
	head.rotation = Vector3.ZERO
	

func reset_target() -> void:
	if enemy: 
		enemy.health_handler.health_drained.disconnect(reset_target)
	enemy = null
	detection_range_collision_shape.shape.size = Vector3.ZERO
	

func _on_shoot_timer_timeout() -> void:
	if enemy:
		var bullet : Bullet = BULLET_SCENE.instantiate()
		get_tree().current_scene.add_child(bullet)
		@warning_ignore("narrowing_conversion")
		bullet.update_damage(damage)
		bullet.global_position = head.global_position
		
		var calculated_bullet_transform  : Transform3D = bullet.transform
		calculated_bullet_transform.basis = head.global_transform.basis
		calculated_bullet_transform.origin = head.global_transform.origin
		
		bullet.transform = calculated_bullet_transform
	
