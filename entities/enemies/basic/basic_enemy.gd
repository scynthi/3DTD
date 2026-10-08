class_name BasicEnemy extends Enemy

@onready var timer: Timer = $Timer
@onready var nav_agent: NavigationAgent3D = $NavAgent
@onready var health_component: HealthComponent = $HealthHandler/HealthComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent

var direction : Vector3 = Vector3.ZERO

func _ready() -> void:
	health_component.max_health = enemy_stats.health
	hitbox_component.damage = enemy_stats.damage
	nav_agent.target_position = global.nexus.global_position
	
	timer.start()
	timer.timeout.connect(_recalculate_path)
	

func _physics_process(_delta: float) -> void:
	velocity = direction * enemy_stats.speed
	
	if global.nexus: look_at(global.nexus.global_position)
	
	move_and_slide()
	

func _recalculate_path() -> void:
	var destination : Vector3 = nav_agent.get_next_path_position()
	var local_destination : Vector3 = destination - global_position
	direction = local_destination.normalized()
	


func _on_health_handler_health_drained() -> void:
	global.player.fragments += enemy_stats.value
	queue_free()
	
