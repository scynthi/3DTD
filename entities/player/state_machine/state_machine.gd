class_name StateMachine extends Node

@export var initial_state : PlayerState
@export var print_debug_messages : bool = true

@onready var player : Player = get_parent()

var states : Dictionary[String, PlayerState] = {}
var current_state : PlayerState = null

func _ready() -> void:
	for child in get_children():
		if child is PlayerState:
			states[child.name.to_lower()] = child
			child.change_state.connect(_on_change_state)
			child.player = player
			child.input_handler = player.input_handler
	
	if initial_state:
		current_state = initial_state
	else:
		current_state = states.get(get_children()[0].name.to_lower())
	
	current_state.enter()
	
	if player.enable_noclip:
		player.input_handler.NOCLIP.triggered.connect(_on_toggle_noclip)
	

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)
		
	

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)
	

func _on_change_state(state_index: int):
	var state = PlayerState.states_dict.get(state_index).to_lower()
	
	if !state:
		push_warning("Unkown state: "+state)
		return
		
	if state.to_lower() == current_state.name.to_lower():
		return
	
	current_state.exit()
	current_state = states.get(state)
	current_state.enter()
	
	if print_debug_messages:
		print("=================================================")
		print("Current State: ", current_state)
	

func _on_toggle_noclip():
	if player.input_handler.NOCLIP.is_triggered():
		if current_state != states.get(PlayerState.states_dict.get(PlayerState.states.NOCLIPSTATE).to_lower()):
			_on_change_state(PlayerState.states.NOCLIPSTATE)
		else:
			_on_change_state(PlayerState.states.INAIRSTATE)
