class_name PortalObject extends Node3D
@warning_ignore("unused_private_class_variable")

@export var normal : Vector3
@export var color : Color = Color.WHITE
@export var detection_shape: Shape3D
@export var teleportation_shape: Shape3D

@onready var vision_mesh : MeshInstance3D = $PortalVisual/VisionMesh
@onready var color_mesh: MeshInstance3D = $PortalVisual/ColorMesh
@onready var camera : Camera3D = $PortalFunctionality/SubViewport/Camera
@onready var subviewport : SubViewport = $PortalFunctionality/SubViewport
@onready var _player_spawn_position : Marker3D = $PortalFunctionality/Markers/PlayerSpawnPosition
@onready var _player_look_position : Marker3D = $PortalFunctionality/Markers/PlayerLookPosition
@onready var _position_markers : Node3D = $PortalFunctionality/Markers
@onready var _space_state : PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
@onready var _placement_validator_raycasts : Array[RayCast3D] = [$PortalFunctionality/Raycasts/RightSurfaceCheck, $PortalFunctionality/Raycasts/LefturfaceCheck, $PortalFunctionality/Raycasts/TopSurfaceCheck, $PortalFunctionality/Raycasts/BottomSurfaceCheck]

var tracked_bodies : Array[Node3D] = []
var other_portal_color : Color
var other_portal : PortalObject
var _saved_player_rotation : float
var _saved_player_velocity : float
var _correct_look_direction : bool = true
var _absolute_up_dot_product : float
var _up_dot_product : float
var _is_first_place_check : bool = true
var _removed_prev_portal : bool = false
var _is_aligned_to_surface : bool = false

func _ready() -> void:
	_setup_camera()
	color_mesh.mesh.material.albedo_color = color
	
	_saved_player_rotation = global.player.camera.global_rotation.y
	
	_up_dot_product = Vector3.UP.dot(normal)
	_absolute_up_dot_product = abs(_up_dot_product)
	
	_position_markers.position.z = -_absolute_up_dot_product
	

func _process(_delta: float) -> void:
	other_portal = get_tree().get_first_node_in_group(str(other_portal_color))
	
	if other_portal:
		camera.global_rotation.y -= 0 + (_saved_player_rotation - global.player.camera.global_rotation.y)
		camera.global_position = other_portal.global_position
		camera.global_transform.basis = other_portal.basis
	
	_update_view()
	

func _physics_process(_delta: float) -> void:
	if !_is_aligned_to_surface:
		_align_portal_to_surface()
	
	if !_validate_placement():
		self.remove_from_group(str(color))
		self.queue_free()
	
	var bodies_in_teleportation_shape : Array[Node3D] = _check_for_collision(teleportation_shape)
	if global.player in bodies_in_teleportation_shape:
		_teleport_entered(global.player)
	
	var bodies_in_detection_shape : Array[Node3D] = _check_for_collision(detection_shape)
	if global.player in bodies_in_detection_shape:
		_detection_entered(global.player)
	elif len(tracked_bodies):
		tracked_bodies = []
	

func _validate_placement() -> bool:
	if _is_first_place_check:
		_is_first_place_check = false
		return true
	
	var current_body : Node3D = _placement_validator_raycasts[0].get_collider()
	var is_valid: bool = true
	
	for raycast : RayCast3D in _placement_validator_raycasts:
		if !raycast.get_collider() || raycast.get_collider() != current_body: is_valid = false
	
	if is_valid && !_removed_prev_portal:
		var prev_portal : PortalObject = get_tree().get_first_node_in_group(str(color))
		if prev_portal:
			prev_portal.remove_from_group(str(color))
			prev_portal.queue_free()
		
		if !self.is_in_group(str(color)):
			self.add_to_group(str(color))
		
		_removed_prev_portal = true
	
	return is_valid
	

func _align_portal_to_surface() -> void:
	if _absolute_up_dot_product == 1.0:
		_player_spawn_position.position.z -= 1.0
		_correct_look_direction = false
		
		var to_player : Vector3 = (global.player.global_transform.origin * Vector3(1.0, 0.0, 1.0) - global_transform.origin * Vector3(1.0, 0.0, 1.0)).normalized()
		var new_basis : Basis = Basis.looking_at(to_player, Vector3.UP) * Basis(Vector3.RIGHT, deg_to_rad(90 * _up_dot_product))
		
		basis = new_basis
	else:
		var forward : Vector3 = -normal.normalized()
		var up : Vector3 = Vector3.UP 
		var right : Vector3 = up.cross(forward).normalized()
		var real_up : Vector3 = forward.cross(right).normalized()
		
		basis = Basis(right, real_up, forward)
	_is_aligned_to_surface = true
	

func _check_for_collision(shape : Shape3D) -> Array[Node3D]:
	var bodies : Array[Node3D] = []
	var query = PhysicsShapeQueryParameters3D.new()
	query.shape = shape
	query.transform = global_transform
	query.collide_with_areas = false
	query.collide_with_bodies = true
	
	for collider_info in _space_state.intersect_shape(query):
		if collider_info.get("collider").is_in_group("ent_obj_teleportation_enabled"):
			bodies.append(collider_info.get("collider"))
	
	return bodies
	

func _detection_entered(body: Node3D) -> void:
	if other_portal:
		if !tracked_bodies.has(body):
			tracked_bodies.append(body)
			
			if body is Player:
				_saved_player_velocity = clampf(global.player.velocity.length(), 0.0, 50.0)
	

func _teleport_entered(body: Node3D) -> void:
	if tracked_bodies.has(body) and other_portal:
		if body is Player:
			global.player.global_position = other_portal._player_spawn_position.global_position
			
			if _correct_look_direction or other_portal._absolute_up_dot_product != 1.0:
				global.player.head.look_at(other_portal._player_look_position.global_position)
				
			global.player.velocity = other_portal.normal * _saved_player_velocity
			global.player.update_velocity()
	

func _update_view() -> void:
	var vision_mesh_material : ShaderMaterial = vision_mesh.get_surface_override_material(0)
	
	if other_portal:
		vision_mesh_material.set("shader_parameter/show_viewport", true)
		vision_mesh_material.set("shader_parameter/viewport", subviewport.get_texture())
	elif vision_mesh_material.get("shader_parameter/show_viewport"):
		vision_mesh_material.set("shader_parameter/show_viewport", false)
		vision_mesh_material.set("shader_parameter/color", color)
	

func _setup_camera() -> void:
	var current_camera : Camera3D = get_viewport().get_camera_3d()
	if !current_camera: return
	
	camera.fov = current_camera.fov
	subviewport.size = get_viewport().get_visible_rect().size
	subviewport.msaa_3d = get_viewport().msaa_3d
	subviewport.screen_space_aa = get_viewport().screen_space_aa
	subviewport.use_taa = get_viewport().use_taa
	subviewport.use_debanding = get_viewport().use_debanding
	subviewport.use_occlusion_culling = get_viewport().use_occlusion_culling
	subviewport.mesh_lod_threshold = get_viewport().mesh_lod_threshold
	
