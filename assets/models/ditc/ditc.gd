class_name Dict extends Node3D

@export var max_distance : float = 1000.0
@export var portal_scene : PackedScene
@export var primary_portal_color : Color
@export var secondary_portal_color : Color

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var portal_to_shoot_by_color : Color

func _ready() -> void:
	portal_to_shoot_by_color = primary_portal_color	
	

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("portal_primary"):
		shoot_portal(primary_portal_color)
	
	if Input.is_action_just_pressed("portal_secondary"):
		shoot_portal(secondary_portal_color)
	

func shoot_portal(color : Color) -> void:
	animation_player.play("shoot")
	
	audio_manager.play_sfx(audio_manager.audio_library.PLAYER_DIE)

	
	var result : Dictionary = _run_raycast()
	if result: 
		_place_portal(result.get("normal"), result.get("position"), result.get("collider"), color)
	

func _place_portal(normal : Vector3, global_pos : Vector3, collider: Node3D, color : Color) -> void:
	var portal_to_shoot : PortalObject = _create_portal_object(color)
	
	if !collider.is_in_group("surf_portal_surface"): return
	portal_to_shoot.normal = normal
	collider.add_child(portal_to_shoot)
	portal_to_shoot.global_position = global_pos
	audio_manager.play_sfx(audio_manager.audio_library.PORTAL_SHOOT)
	
	

func _create_portal_object(color: Color) -> PortalObject:
	var portal : PortalObject = portal_scene.instantiate()
	portal.color = color
	portal.other_portal_color = primary_portal_color if color == secondary_portal_color else secondary_portal_color
	
	return portal
	

func _run_raycast() -> Dictionary:
	var space_state : PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var from : Vector3 = global.player.camera.global_position
	var to : Vector3 = from + global.player.camera.global_transform.basis.z * -max_distance  # Forward is -Z
	
	var query : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from, to)
	query.collide_with_areas = false
	query.collision_mask = 4294967293
	query.collide_with_bodies = true
	
	return space_state.intersect_ray(query)
