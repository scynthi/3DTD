class_name BasicEnemy extends CharacterBody3D

@export var speed : float = 2.5

@onready var timer: Timer = $Timer
@onready var nav_agent: NavigationAgent3D = $NavAgent

var direction : Vector3 = Vector3.ZERO

func _ready() -> void:
	nav_agent.target_position = global.nexus.global_position
	timer.start()
	timer.timeout.connect(_recalculate_path)
	_recalculate_path()
	

func _physics_process(_delta: float) -> void:
	velocity = direction * speed
	move_and_slide()
	

func _recalculate_path() -> void:
	var destination : Vector3 = nav_agent.get_next_path_position()
	var local_destination = destination - global_position
	direction = local_destination.normalized()
	
