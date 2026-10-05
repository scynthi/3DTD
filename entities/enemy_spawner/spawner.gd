class_name EnemySpawner extends Node3D

@export var map_floor : Node3D

@onready var spawn_area : CollisionShape3D = $Area3D/SpawnArea
const ENEMY_SCENE : PackedScene = preload("res://entities/enemies/basic/basic_enemy.tscn")

var amount : int = 10


func spawn_enemies() -> void:
	for i : int in range(amount):
		var current_enemy : Enemy = ENEMY_SCENE.instantiate()
		
		await get_tree().create_timer(0.5).timeout
		
		get_tree().current_scene.add_child(current_enemy)
		current_enemy.global_position = randomize_enemy_spawn_position()
		
	


func randomize_enemy_spawn_position() -> Vector3:
	var spawn_area_global_pos : Vector3 = spawn_area.global_position
	var spawn_area_size : Vector3 = spawn_area.shape.size
	
	var randomized_x_pos : float = randf_range(spawn_area_global_pos.x, spawn_area_global_pos.x - spawn_area_size.x)
	var randomized_z_pos : float = randf_range(spawn_area_global_pos.z, spawn_area_global_pos.z + spawn_area_size.z)
	
	return Vector3(randomized_x_pos, map_floor.global_position.y, randomized_z_pos)
	
