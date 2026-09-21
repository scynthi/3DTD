class_name RunningState extends PlayerState

func enter() -> void:
	player.speed = player.sprint_speed
	input_handler.space_just_pressed.connect(_change_state_to_jump)
	

func exit() -> void:
	input_handler.space_just_pressed.disconnect(_change_state_to_jump)
	

func _change_state_to_jump():
	change_state.emit(states.JUMPSTATE)

func update(_delta : float) -> void:
	if not input_handler.is_shift_held and player.get_horizontal_speed() < player.auto_run_speed_threshold:
		change_state.emit(states.WALKSTATE)
	
	if player.can_slide():
		change_state.emit(states.SLIDESTATE)
	
	if !player.is_on_floor():
		change_state.emit(states.INAIRSTATE)
	
	

func physics_update(delta : float) -> void:
	player.update_gravity(delta)
	player._use_default_movement_handler(delta)
	
