extends Node3D

@onready var func_godot_map: FuncGodotMap = $FuncGodotMap


func _ready() -> void:
	func_godot_map.build_map()
	
