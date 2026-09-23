class_name NoClipState extends PlayerState

var position_add_amount : float = 1.0


func enter() -> void:
	pass
	

func update(_delta : float) -> void:
	pass
	

func physics_update(_delta : float) -> void:
	player.global_position += player.get_wish_direction() * position_add_amount * Vector3(1, 0, 1)
	
	if input_handler.is_control_held:
		player.global_position.y -= position_add_amount
	
	if input_handler.is_space_held:
		player.global_position.y += position_add_amount
	

func exit() -> void:
	pass
