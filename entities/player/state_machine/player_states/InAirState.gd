class_name InAirState extends PlayerState

var saved_velocity : Vector3
var should_apply_gravity : bool = true

func enter() -> void:
	saved_velocity = player.velocity
	
	input_handler.shift_just_pressed.connect(_change_state_to_dash)
	input_handler.space_just_pressed.connect(_change_state_to_jump)
	

func exit() -> void:
	input_handler.space_just_pressed.disconnect(_change_state_to_jump)
	input_handler.shift_just_pressed.disconnect(_change_state_to_dash)
	

func _change_state_to_dash():
	change_state.emit(states.DASHSTATE)

func _change_state_to_jump():
	change_state.emit(states.JUMPSTATE)

func update(_delta : float) -> void:
	if player.can_wallrun():
		change_state.emit(states.WALLRUNSTATE)
	
	if player.can_slide():
		change_state.emit(states.SLIDESTATE)
	
	if player.is_on_floor():
		if !player.jump_buffer.is_stopped():
			change_state.emit(states.JUMPSTATE)
		else:
			change_state.emit(states.RUNSTATE)
	
	

func physics_update(delta : float) -> void:
	player.update_gravity(delta)
	
	var wish_dir : Vector3 = player.get_wish_direction()
	var speed : float = (saved_velocity * Vector3(1.0, 0.0, 1.0)).length()
	var new_velocity : Vector3 = wish_dir * speed
	
	var dot_product : float = abs(saved_velocity.normalized().dot(wish_dir))
	var transition_time : float = delta * dot_product * 2.0
	
	if new_velocity == Vector3.ZERO:
		new_velocity = wish_dir * 10.0
	
	if transition_time < 1.0:
		transition_time = delta * 0.5
	
	player.velocity.x = lerp(player.velocity.x, new_velocity.x, transition_time)
	player.velocity.z = lerp(player.velocity.z, new_velocity.z, transition_time)
	
	player.update_velocity()
	
