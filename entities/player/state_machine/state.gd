class_name PlayerState extends Node

@warning_ignore("unused_signal")
signal change_state

var player : Player = null
var input_handler : InputHandler = null
enum states {WALKSTATE, JUMPSTATE, INAIRSTATE, RUNSTATE, CROUCHSTATE, SLIDESTATE, DASHSTATE, WALLRUNSTATE, NOCLIPSTATE}
const states_dict = {
	states.WALKSTATE: "WalkState", 
	states.JUMPSTATE: "JumpState", 
	states.INAIRSTATE : "InAirState", 
	states.RUNSTATE : "RunState", 
	states.CROUCHSTATE: "CrouchState", 
	states.SLIDESTATE : "SlideState", 
	states.DASHSTATE : "DashState", 
	states.WALLRUNSTATE : "WallrunState",
	states.NOCLIPSTATE : "NoClipState"
}

func enter() -> void:
	pass

func update(_delta : float) -> void:
	pass

func physics_update(_delta : float) -> void:
	pass

func exit() -> void:
	pass
