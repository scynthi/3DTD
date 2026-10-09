class_name HealthComponent extends Node3D

@export var max_health : float = 10.0
@export var regen_time : float = 2.5
@export var regen_amount : float = 1.0

@onready var regen_timer: Timer = $RegenTimer

signal died

var current_health : float
var enabled_health_overflow : bool = true
var overheal_effect_duration : float = 2.0

func _ready() -> void:
	if regen_time > 0.0: 
		regen_timer.wait_time = regen_time
		regen_timer.start(regen_time)
		
	
	fullheal()
	

func _physics_process(delta: float) -> void:
	if current_health > max_health:
		current_health = lerpf(current_health, max_health, delta * overheal_effect_duration)
		
	
	if regen_timer.is_stopped() and regen_time > 0.0 and current_health < max_health:
		regen_timer.start(regen_time)
		
	

func heal(amount : float) -> void:
	current_health += amount
	

func fullheal() -> void:
	current_health = max_health
	

func damage(amount : float) -> void:
	current_health -= amount
	
	if current_health <= 0.0:
		regen_timer.stop()
		current_health = -1
		died.emit()
		return
		
	

func _on_regen_timer_timeout() -> void:
	heal(regen_amount)
	
