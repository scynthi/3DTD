class_name EnemySpawner extends Node3D

@onready var spawn_area : CollisionShape3D = $Area3D/SpawnArea


@onready var enemy_scenes : Array[PackedScene] = [preload("res://entities/enemies/basic/basic_enemy.tscn")]
var amount_dict : Dictionary[String, int] = {"basic": 10, "advanced": 0, "maxed": 0}


func spawn_enemies() -> void:
	for key : String in amount_dict.keys():
		var current_enemy_scene : PackedScene = enemy_scenes[amount_dict.keys().find(key)]
		
		if amount_dict[key] <= 0: continue
		
		for amount in range(amount_dict[key]):
			await get_tree().create_timer(0.2).timeout
			
			var current_enemy : Enemy = current_enemy_scene.instantiate()
			
			current_enemy.process_mode = Node.PROCESS_MODE_DISABLED
			get_tree().current_scene.add_child(current_enemy)
			current_enemy.global_position = randomize_enemy_spawn_position()
			current_enemy.process_mode = Node.PROCESS_MODE_ALWAYS
			
		
	

func randomize_enemy_spawn_position() -> Vector3:
	var spawn_area_global_pos : Vector3 = spawn_area.global_position
	var spawn_area_size : Vector3 = spawn_area.shape.size
	
	var randomized_x_pos : float = randf_range(-spawn_area_size.x, spawn_area_size.x) / 2
	var randomized_z_pos : float = randf_range(-spawn_area_size.z, spawn_area_size.z) / 2
	
	return Vector3(spawn_area_global_pos.x - randomized_x_pos, spawn_area_global_pos.y, spawn_area_global_pos.z - randomized_z_pos)
	
