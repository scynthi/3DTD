class_name DashState extends PlayerState

func enter() -> void:
	if !player.dash_cooldown_timer.is_stopped():
		change_state.emit(states.INAIRSTATE)
	else:
		player.dash_cooldown_timer.start()
	

func update(_delta : float) -> void:
	pass

func physics_update(_delta : float) -> void:
	var wish_dir : Vector3 = player.get_wish_direction()
	player.velocity += wish_dir * Vector3(player.dash_speed, 1.0, player.dash_speed)
	
	player.update_velocity()
	change_state.emit(states.INAIRSTATE)
	

func exit() -> void:
	pass
