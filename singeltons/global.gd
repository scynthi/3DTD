extends Node

var player : SpectatorPlayerCamera = null
var nexus : Nexus = null

enum TOWER_PROPERTIES {
	ATTACK_SPEED,
	DAMAGE,
	RANGE,
	HEALTH
}

func update_tower_property(property : TOWER_PROPERTIES, value : float):
	var towers := get_tree().get_nodes_in_group("towers")
	
	for tower : Tower in towers:
		match property:
			TOWER_PROPERTIES.ATTACK_SPEED:
				tower.update_attack_speed(value)
			TOWER_PROPERTIES.DAMAGE:
				tower.update_damage(value)
			TOWER_PROPERTIES.RANGE:
				tower.update_detection_range(value)
			TOWER_PROPERTIES.HEALTH:
				tower.update_health(value)
		
	
