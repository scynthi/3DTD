class_name SlideState extends PlayerState

func enter() -> void:
	input_handler.space_just_pressed.connect(_change_state_to_jump)
	

func exit() -> void:
	input_handler.space_just_pressed.disconnect(_change_state_to_jump)
	

func _change_state_to_jump():
	change_state.emit(states.JUMPSTATE)

func update(_delta : float) -> void:
	if !input_handler.is_control_held:
		change_state.emit(states.RUNSTATE)
	
	if !player.can_slide():
		change_state.emit(states.INAIRSTATE)

func physics_update(delta : float) -> void:
	player.update_gravity(delta)
	var slope_slopeness : float = 1+Vector3.UP.dot(player.get_floor_normal())
	
	player.velocity = lerp(player.velocity, player.get_slope_direction()*player.max_slide_speed + player.get_wish_direction()*player.deviation_power, delta*player.slide_acceleration_speed*slope_slopeness)
	
	player.update_velocity()
	
