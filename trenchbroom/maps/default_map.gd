extends Node3D

@onready var enemy_spawner : EnemySpawner = $Map/EnemySpawner

func _ready() -> void:
	enemy_spawner.amount = 10
	enemy_spawner.spawn_enemies()
	
