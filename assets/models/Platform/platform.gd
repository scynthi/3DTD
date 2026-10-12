class_name Platform extends StaticBody3D

@export var has_tower : bool = false
@export var is_enabled : bool = true
@export var tower_level : int = 0
@export var placed_tower : Tower = null

func set_tower_level(tower : Tower) -> void:
	if placed_tower: placed_tower.queue_free()
	
	if tower is BasicTower : tower_level = 1
	elif tower is AdvancedTower : tower_level = 2
	else: tower_level = 3
	
	placed_tower = tower
	has_tower = true
	
