class_name HealthHandler extends Node3D

@export var health_component : HealthComponent
@export var shield_component : ShieldComponent

#TODO: code heal component for shield component
signal health_drained
signal shield_drained
@warning_ignore("unused_signal")
signal heal_received
@warning_ignore("unused_signal")
signal shield_received

func _ready() -> void:
	if health_component:
		health_component.died.connect(health_drained.emit)
	
	if shield_component:
		shield_component.died.connect(shield_drained.emit)
	

func damage(amount : float) -> void:
	if shield_component:
		if shield_component.current_shield >= amount:
			shield_component.damage(amount)
		else:
			var overflow_damage : float = amount - shield_component.current_shield
			shield_component.damage(shield_component.current_shield)
			health_component.damage(overflow_damage)
	else:
		health_component.damage(amount)
	

func heal(amount : float) -> void:
	health_component.heal(amount)
	

func fullheal() -> void:
	health_component.fullheal()
	
