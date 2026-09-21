class_name JumpState extends PlayerState


func enter() -> void:
	if player.is_on_floor() || !player.wall_run_cooldown_timer.is_stopped() || !player.coyote_timer.is_stopped():
		player.jump_buffer.stop()
		player.coyote_timer.stop()
	elif player.jumps_left < 1:
		change_state.emit(states.INAIRSTATE)
	else:
		player.jumps_left -= 1
	

func update(_delta : float) -> void:
	pass

func physics_update(delta : float) -> void:
	player.velocity.y = 0.0
	player.velocity.y = player.jump_velocity
	player.update_gravity(delta)
	player.update_velocity()
	change_state.emit(states.INAIRSTATE)
	

func exit() -> void:
	pass
