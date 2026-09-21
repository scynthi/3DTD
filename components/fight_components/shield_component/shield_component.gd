class_name ShieldComponent extends Node3D

@export var max_shield : float = 10.0

signal died

var current_shield : float

func _ready() -> void:
	current_shield = max_shield
	

func damage(amount : float) -> void:
	current_shield -= amount
	
	if current_shield <= 0.0:
		died.emit()
