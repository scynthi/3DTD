extends Node3D

@onready var enemy_spawner : EnemySpawner = $Map/EnemySpawner
@onready var nexus: Nexus = $Map/Nexus

func _ready() -> void:
	#enemy_spawner.amount = 10
	enemy_spawner.spawn_enemies()
	
	nexus.health_component.died.connect(dead)
	

func dead() -> void:
	scene_loader.load_ui_scene(scene_loader.ui_scenes.death_screen, false)
	
