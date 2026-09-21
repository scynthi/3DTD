class_name HealthComponent extends Node3D

@export var max_health : float = 10.0

signal died

var current_health : float
var enabled_health_overflow : bool = true
var overheal_effect_duration : float = 2.0

func _ready() -> void:
	fullheal()
	

func _physics_process(delta: float) -> void:
	if current_health > max_health:
		current_health = lerpf(current_health, max_health, delta * overheal_effect_duration)
	

func heal(amount : float) -> void:
	current_health += amount
	

func fullheal() -> void:
	current_health = max_health
	

func damage(amount : float) -> void:
	current_health -= amount
	
	if current_health <= 0.0:
		died.emit()
	
