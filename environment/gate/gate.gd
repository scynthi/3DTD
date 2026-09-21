@tool
class_name Gate extends Node3D

@export var amount : float = 5.0
@export var speed : float = 1.0
@export var open_when_ready : bool = false
@export var open_with_delay : float = 0.0
@export var is_open : bool = false :
	set(value):
		if !is_moving and is_inside_tree():
			is_open = value
			
			if value:
				pos = global_position.y + amount
			else:
				pos = global_position.y - amount
			
			is_moving = true
			

@onready var is_moving : bool = false
var pos : float

func _ready() -> void:
	if !Engine.is_editor_hint() and open_when_ready:
		if open_with_delay > 0.0:
			await get_tree().create_timer(open_with_delay).timeout
		is_open = true

func _physics_process(delta: float) -> void:
	if is_moving:
		if abs(global_position.y - pos) < 0.0001:
			is_moving = false
			global_position.y = pos
		else:
			global_position.y = lerpf(global_position.y, pos, delta * speed)
	
