class_name WalkingState extends PlayerState

func enter() -> void:
	player.speed = player.walk_speed
	
	input_handler.space_just_pressed.connect(_change_state_to_jump)
	

func exit() -> void:
	input_handler.space_just_pressed.disconnect(_change_state_to_jump)
	

func _change_state_to_jump():
	change_state.emit(states.JUMPSTATE)

func update(_delta : float) -> void:
	if input_handler.is_shift_held or player.get_horizontal_speed() > player.auto_run_speed_threshold:
		change_state.emit(states.RUNSTATE)
	
	if input_handler.is_control_held and !input_handler.is_shift_held:
		change_state.emit(states.CROUCHSTATE)
	
	if !player.is_on_floor():
		change_state.emit(states.INAIRSTATE)
	

func physics_update(delta : float) -> void:
	player.update_gravity(delta)
	player._use_default_movement_handler(delta)
	
