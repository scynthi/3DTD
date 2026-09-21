@tool
class_name PlayerUI extends Control

@export_enum("None", "All", "Dot", "FourCross") var crosshair_type : int = 2
@export var crosshair_center_offset : Vector2 = Vector2(0.0, 0.0)
@export var player : Player
@export_group("Dot")
@export var dot_radius : float = 2.5
@export var dot_border : float = 1.0
@export var dot_is_filled : bool = true
@export var dot_color : Color = Color.WHITE
@export var dot_draw_outline : bool = false
@export var dot_outline_size : float = 0.7
@export var dot_outline_color : Color = Color.BLACK
@export var dot_outline_width : float = 1.0
@export_group("FourCross")
@export var fourcross_center_offset : float = 2.5
@export var use_velocity_offset : bool = true
@export var offset_default : float = 5.0
@export var offset_maximum : float = 50.0
@export var fourcross_length : float = 12.0
@export var fourcross_width : float = 2.0
@export var fourcross_color : Color = Color.WHITE
@export var fourcross_draw_outline : bool = false
@export var fourcross_outline_color : Color = Color.BLACK
@export var fourcross_outline_size : float = 3.0

var _cross_hair_position : Vector2

func _process(_delta: float) -> void:
	_cross_hair_position = get_viewport_rect().get_center() - crosshair_center_offset
	queue_redraw()

func _draw() -> void:
	match crosshair_type:
		0: pass
		1: 
			_draw_dot_crosshair()
			_draw_fourcross_crosshair()
		2: _draw_dot_crosshair()
		3: _draw_fourcross_crosshair()

func _draw_fourcross_crosshair():
	var offset : float = offset_default
	
	if player:
		var velocit_length_clamped : float = clampf(player.velocity.length(), offset_default, offset_maximum)
		offset = lerpf(offset_default, velocit_length_clamped, 0.25)
	
	var offset_horizontal : Vector2 = Vector2(offset, 0.0)
	var offset_vertical : Vector2 = Vector2(0.0, offset)
	
	var center : Vector2 = _cross_hair_position
	var horizontal_start : Vector2 = Vector2(fourcross_length, 0.0)
	var vertical_start : Vector2 = Vector2(0.0, fourcross_length)
	
	var center_offset_horizontal : Vector2 = Vector2(fourcross_center_offset, 0.0)
	var center_offset_vertical : Vector2 = Vector2(0.0, fourcross_center_offset)
	
	var left_start_pos : Vector2 = center - horizontal_start - offset_horizontal
	var right_start_pos : Vector2 = center + horizontal_start + offset_horizontal
	var bottom_start_pos : Vector2 = center + vertical_start + offset_vertical
	var top_start_pos : Vector2 = center - vertical_start - offset_vertical
	
	if fourcross_draw_outline:
		var horizontal_outline_position_offset : Vector2 = Vector2(fourcross_outline_size, 0.0)/2
		var vertical_outline_position_offset : Vector2 = Vector2(0.0, fourcross_outline_size)/2
		
		draw_line(left_start_pos - horizontal_outline_position_offset, center - center_offset_horizontal - offset_horizontal + horizontal_outline_position_offset, fourcross_outline_color, fourcross_outline_size, true) ## left
		draw_line(right_start_pos + horizontal_outline_position_offset, center + center_offset_horizontal + offset_horizontal - horizontal_outline_position_offset, fourcross_outline_color, fourcross_outline_size, true) ## right
		draw_line(top_start_pos - vertical_outline_position_offset, center - center_offset_vertical - offset_vertical + vertical_outline_position_offset, fourcross_outline_color, fourcross_outline_size, true) ## top
		draw_line(bottom_start_pos + vertical_outline_position_offset, center + center_offset_vertical + offset_vertical - vertical_outline_position_offset, fourcross_outline_color, fourcross_outline_size, true) ## bottom
	
	draw_line(left_start_pos, center - center_offset_horizontal - offset_horizontal, fourcross_color, fourcross_width, true) ## left
	draw_line(right_start_pos, center + center_offset_horizontal + offset_horizontal, fourcross_color, fourcross_width, true) ## right
	draw_line(top_start_pos, center - center_offset_vertical - offset_vertical, fourcross_color, fourcross_width, true) ## top
	draw_line(bottom_start_pos, center + center_offset_vertical + offset_vertical, fourcross_color, fourcross_width, true) ## bottom
	

func _draw_dot_crosshair():
	if dot_draw_outline:
		draw_circle(_cross_hair_position, dot_radius+dot_outline_size, dot_outline_color, false, dot_outline_width, true)
	
	if dot_is_filled:
		draw_circle(_cross_hair_position, dot_radius, dot_color, dot_is_filled, -1, true)
	else:
		draw_circle(_cross_hair_position, dot_radius, dot_color, dot_is_filled, dot_border, true)
		
