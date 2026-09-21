class_name CrouchState extends PlayerState

func enter() -> void:
	player.animation_player.play("crouch_start")
	player.speed = player.crouch_speed

func update(_delta : float) -> void:
	if not input_handler.is_control_held:
		change_state.emit(states.WALKSTATE)

func physics_update(delta : float) -> void:
	player.update_gravity(delta)
	player._use_default_movement_handler(delta)

func exit() -> void:
	player.animation_player.play("crouch_end")
