extends Node

var player : SpectatorPlayerCamera = null
var nexus : Nexus = null

var tower_data : TowerData = TowerData.new()
var enemy_data : EnemyStat = EnemyStat.new()

var infinite_fragment : bool = false
var current_wave : int = 0
var last_wave : int = 20


func update_tower_property():
	var towers := get_tree().get_nodes_in_group("towers")
	
	for tower : Tower in towers:
		tower.update_attack_speed(tower_data.attack_speed)
		tower.update_damage(tower_data.damage)
		tower.update_detection_range(tower_data.detection_range)
		tower.update_health(tower_data.health)
		
	
	
