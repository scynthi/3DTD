extends Node3D

@onready var gpu_particles_left: GPUParticles3D = $GPUParticlesLeft
@onready var gpu_particles_right: GPUParticles3D = $GPUParticlesRight
@onready var particle_animation_player: AnimationPlayer = $ParticleAnimationPlayer

@export var player : Player

func _process(_delta: float) -> void:
	if player.velocity.length() > player.wind_effect_required_speed:
		gpu_particles_left.emitting = true
		gpu_particles_right.emitting = true
		
	elif gpu_particles_left.emitting:
		particle_animation_player.play("wind_end")
	

func _physics_process(_delta: float) -> void:
	if player.velocity.length() > player.wind_effect_required_speed:
		look_at(global_position + player.velocity.normalized())
	
