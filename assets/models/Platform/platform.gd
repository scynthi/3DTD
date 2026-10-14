class_name Platform extends StaticBody3D

@export var has_tower : bool = false
@export var is_enabled : bool = true
@export var tower_level : int = 0
@export var placed_tower : Tower = null

func set_tower_level(tower : Tower) -> void:
	if placed_tower: _remove_tower()
	
	if tower is BasicTower : tower_level = 1
	elif tower is AdvancedTower : tower_level = 2
	else: tower_level = 3
	
	placed_tower = tower
	placed_tower.health_component.died.connect(_remove_tower)
	has_tower = true
	

func _remove_tower() -> void:
	placed_tower.health_component.died.disconnect(_remove_tower)
	placed_tower.queue_free()
	placed_tower = null
	tower_level = 0
	has_tower = false
	
