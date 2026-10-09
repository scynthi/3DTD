extends Node3D

@onready var enemy_spawner : EnemySpawner = $Map/EnemySpawner
@onready var nexus: Nexus = $Map/Nexus
@onready var wave_timer: Timer = $WaveTimer
@onready var count_enemies_timer: Timer = $CountEnemiesTimer

var wave_ongoing : bool = false

func _ready() -> void:
	nexus.health_component.died.connect(dead)
	

func dead() -> void:
	await get_tree().create_timer(0.2).timeout
	scene_loader.load_ui_scene(scene_loader.ui_scenes.death_screen, false)
	

func _on_wave_timer_timeout() -> void:
	if global.current_wave == global.last_wave:
		print("yo woned")
		return
		
	
	global.current_wave += 1
	
	enemy_spawner.amount_dict["basic"] += 1
	enemy_spawner.amount_dict["advanced"] += 1
	
	global.enemy_data.health += 1
	global.enemy_data.damage += 1
	
	enemy_spawner.spawn_enemies()
	

func _on_count_enemies_timer_timeout() -> void:
	var enemies := get_tree().get_nodes_in_group("enemy")
	
	if len(enemies) == 0:
		wave_ongoing = false
	
	if !wave_ongoing:
		wave_timer.start()
		wave_ongoing = true
		
	
