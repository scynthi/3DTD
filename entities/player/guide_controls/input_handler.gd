class_name InputHandler extends Node

@export_category("GUIDE")
@export var MAPPING_CONTEXT : GUIDEMappingContext
@export var BASIC_MOVEMENT : GUIDEAction
@export var ROTATE_PLAYER : GUIDEAction
@export var ROTATE_CAMERA : GUIDEAction
@export var SHIFT : GUIDEAction
@export var SPACE : GUIDEAction
@export var CONTROL : GUIDEAction
@export var NOCLIP : GUIDEAction
@export var CAMERA_SWITCH : GUIDEAction

var is_shift_held : bool
var is_space_held : bool
var is_control_held : bool
var movement_vector : Vector3

signal shift_just_pressed
signal space_just_pressed
signal control_just_pressed
signal camera_switch_just_pressed

func _ready() -> void:
	GUIDE.enable_mapping_context(MAPPING_CONTEXT)
	
	SHIFT.triggered.connect(shift_just_pressed.emit)
	SPACE.triggered.connect(space_just_pressed.emit)
	CONTROL.triggered.connect(control_just_pressed.emit)
	CAMERA_SWITCH.triggered.connect(camera_switch_just_pressed.emit)
	

func _process(_delta: float) -> void:
	is_shift_held = SHIFT.value_bool
	is_space_held = SPACE.value_bool
	is_control_held = CONTROL.value_bool
	
	movement_vector = BASIC_MOVEMENT.value_axis_3d
	

func disable_input() -> void:
	GUIDE.disable_mapping_context(MAPPING_CONTEXT)
	
