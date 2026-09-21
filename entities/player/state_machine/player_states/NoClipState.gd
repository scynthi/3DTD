class_name NoClipState extends PlayerState

var position_add_amount : float
var default_add_amount : float = 0.5
var max_add_amount : float = 2.5

func enter() -> void:
	player.velocity = Vector3.ZERO
	

func update(_delta : float) -> void:
	if input_handler.is_shift_held:
		position_add_amount = max_add_amount
	else:
		position_add_amount = default_add_amount
	

func physics_update(_delta : float) -> void:
	player.global_position += player.get_wish_direction() * position_add_amount
	
	if input_handler.is_control_held:
		player.global_position.y -= position_add_amount
	
	if input_handler.is_space_held:
		player.global_position.y += position_add_amount
	

func exit() -> void:
	pass
