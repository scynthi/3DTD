class_name WallrunningState extends PlayerState

func enter() -> void:
	player.velocity.y = 0.0
	
	if player.get_horizontal_speed() < player.wallrun_require_speed:
		change_state.emit(states.INAIRSTATE)
		return
	
	input_handler.space_just_pressed.connect(_change_state_to_jump)
	
	player.reset_jumps()
	player.reload_dash()
	

func exit() -> void:
	if input_handler.space_just_pressed.is_connected(_change_state_to_jump):
		input_handler.space_just_pressed.disconnect(_change_state_to_jump)
	player.wall_run_cooldown_timer.start()
	

func _change_state_to_jump():
	var correction : float = player.wallrun_direction_correction
	var correct_direction : Vector3 = player.get_wall_normal_failsafe().normalized() / correction
	
	player.velocity = (player.velocity.normalized() + correct_direction) * player.get_horizontal_speed()
	
	change_state.emit(states.JUMPSTATE)
	

func update(delta : float) -> void:
	if !player.is_next_to_wall() || (player.enable_wall_kick_off && player.max_wallrun_time <= 0.0) or player.get_horizontal_speed() < player.wallrun_require_speed:
		change_state.emit(states.INAIRSTATE)
	
	if player.enable_wall_kick_off:
		player.max_wallrun_time -= delta
	

func physics_update(delta : float) -> void:
	if player.use_wallrun_acceleration and player.get_horizontal_speed() < player.wallrun_speed:
		var dir : Vector3 = player.velocity.normalized()
		var speed_vector : Vector3 = dir*player.wallrun_speed
		
		player.velocity = lerp(player.velocity, speed_vector, delta*player.wallrun_lerp_speed)
	
	if player.enable_vertical_movement:
		player.velocity.y = player.fps_camera.rotation.x * 10.0
	
	player.update_velocity()
	
