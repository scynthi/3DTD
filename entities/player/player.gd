class_name Player extends CharacterBody3D

@export_group("Auxiliary Systems")
@export var input_handler : InputHandler

@export_group("Movement")
@export var enable_noclip : bool = false
@export_subgroup("Ground motion")
@export var crouch_speed : float = 2.5
@export var walk_speed : float = 7.5
@export var sprint_speed : float = 15.0
@export var auto_run_speed_threshold : float = 20.0
@export_subgroup("Air motion")
@export var jump_count : int = 1
@export var jump_velocity : float = 12.0
@export var jump_cooldown : float = 2.0
@export var jump_buffer_wait_time : float = 0.2
@export var coyote_timer_wait_time : float = 0.2
@export var gravity : float = 9.8
@export var default_gravity_scale : float = 2.0
@export var dash_speed : float = 10.0
@export var dash_cooldown : float = 5.0
@export var air_control : float = 1.0
@export_subgroup("Wallrun settings")
@export var wallrun_require_speed : float = 4.0
@export var use_wallrun_acceleration : bool = true
@export var wallrun_speed : float = 20.0
@export var wallrun_lerp_speed : float = 5
@export var enable_vertical_movement : bool = true
@export var enable_wall_kick_off : bool = false
@export var max_wallrun_time : float = 0.0
@export var wallrun_direction_correction : float = 3.0
@export_subgroup("Slide Settings")
@export var max_slide_speed : float = 60.0
@export var slide_acceleration_speed : float = 1.0
@export var deviation_power : float = 10.0

@export_group("Camera Settings")
@export_range(1, 150) var base_fov : float = 90.0
@export_range(0, 10) var fov_change : float = 1.1
@export_range(0, 100) var mouse_sensitivity : float = 1.0
@export_range(0, 10) var camera_smooth_lag : float = 4.0
@export var max_camera_x_rotation : float = 90.0
@export_subgroup("Head bob")
@export var headbob_enabled : bool = true
@export_range(1, 20) var bob_frequency : float = 2.0
@export_range(1, 20) var bob_amplitude : float = 5.0
@export_subgroup("Impact effect")
@export var impact_effect_enabled : bool = true
@export var min_impact_speed : float = 1.0
@export var max_impact_speed : float = 10.0
@export var min_impact_strength : float = 0.8
@export var max_impact_strength : float = 2
@export var falling_rotation : float = 0.3
@export var impact_rotation : float = -0.2
@export var min_speed_required : float = 10.0
@export_subgroup("Wallrun tilt")
@export var tilt_amount : float = 0.2
@export_subgroup("Wind particles")
@export var wind_effect_required_speed : float = 40.0

@onready var head : Node3D = $Head
@onready var camera_smooth: Node3D = $Head/CameraSmooth

@onready var fps_camera: Camera3D = $Head/CameraSmooth/FPSCamera
@onready var tps_camera: Camera3D = $Head/CameraSmooth/TPSSpring/TPSCamera

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var jump_cooldown_timer: Timer = $Timers/JumpCooldownTimer
@onready var dash_cooldown_timer: Timer = $Timers/DashCooldownTimer
@onready var wall_run_cooldown_timer: Timer = $Timers/WallRunCooldownTimer
@onready var coyote_timer: Timer = $Timers/CoyoteTimer
@onready var jump_buffer: Timer = $Timers/JumpBuffer

@onready var slope_check_shapecast: ShapeCast3D = $Head/SlopeCheckShapecast
@onready var left_wall_check_shapecast: ShapeCast3D = $Head/LeftWallCheckShapecast
@onready var right_wall_check_shapecast: ShapeCast3D = $Head/RightWallCheckShapecast

var timer : float
var time : float
var speed : float
var jumps_left : int

var _gravity_scale : float
var _t_bob : float = 0.0
var _camera_smooth_pos_diff : Vector3
var _wallrun_camera_tilt_amount : float
var _speed_descrease_value : float = 0.0
var _camera_min_vertical_angle_increase_value : float = 0.0

func _ready():
	global.player = self
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	jumps_left = jump_count
	_gravity_scale = default_gravity_scale
	
	jump_cooldown_timer.wait_time = jump_cooldown
	dash_cooldown_timer.wait_time = dash_cooldown
	coyote_timer.wait_time = coyote_timer_wait_time
	jump_buffer.wait_time = jump_buffer_wait_time
	
	jump_cooldown_timer.timeout.connect(_on_jump_cooldown_timer_timeout)
	dash_cooldown_timer.timeout.connect(_on_dash_cooldown_timer_timeout)
	
	input_handler.camera_switch_just_pressed.connect(_switch_cameras)
	

func _switch_cameras() -> void:
	fps_camera.current = tps_camera.current
	tps_camera.current = !fps_camera.current
	head.rotation.x = 0
	

func _process(_delta: float) -> void:
	_handle_jumps()
	

func _handle_head(delta: float) -> void:
	_camera_smooth_pos_diff = Vector3.ZERO
	if get_wish_direction(): _camera_smooth_pos_diff = camera_smooth_lag * 0.1 * velocity.normalized()
	camera_smooth.global_position = lerp(camera_smooth.global_position, head.global_position-_camera_smooth_pos_diff, delta)
	
	head.rotation_degrees.y += input_handler.ROTATE_PLAYER.value_axis_1d * mouse_sensitivity
	
	if is_on_floor() && !can_slide(): _apply_headbob(delta)
	
	if fps_camera.current:
		if fps_camera.rotation.y != 0.0: fps_camera.rotation_degrees.y = lerpf(fps_camera.rotation_degrees.y, 0.0, delta)
		
		fps_camera.rotation_degrees.x = clamp(fps_camera.rotation_degrees.x + input_handler.ROTATE_CAMERA.value_axis_1d * mouse_sensitivity, -max_camera_x_rotation-_camera_min_vertical_angle_increase_value, max_camera_x_rotation)
		_camera_fov_change(delta)
		_camera_impact_effect(delta)
		_camera_wallrun_tilt_effect(delta)
	else:
		head.rotation_degrees.x = clamp(head.rotation_degrees.x + input_handler.ROTATE_CAMERA.value_axis_1d * mouse_sensitivity, -max_camera_x_rotation-_camera_min_vertical_angle_increase_value, max_camera_x_rotation)
		

func _physics_process(delta: float) -> void:
	_handle_head(delta)
	
	if is_on_floor() && get_wish_direction() && !can_slide():
		if speed == walk_speed:
			time = 0.4
		elif speed == sprint_speed:
			time = 0.3
		else:
			time = 0.8
		
		if timer > 0.0:
			timer -= delta
		else:
			audio_manager.play_sfx(audio_manager.audio_library.STEPS)
			timer = time

func _handle_jumps():
	if jump_count:
		if jumps_left == 0 and jump_cooldown_timer.is_stopped():
			jump_cooldown_timer.start()
			

func _use_default_movement_handler(delta : float) -> void:
	var length : float = (velocity * Vector3(1,0,1)).length()
	var current_speed : float = speed if (length < sprint_speed) else length
	var wish_direction : Vector3 = get_wish_direction()
	var new_velocity : Vector3 = wish_direction * current_speed
	var max_velocity : Vector3 = wish_direction * speed
	
	if new_velocity > max_velocity:
		_speed_descrease_value += delta
		new_velocity = get_wish_direction() * (current_speed - _speed_descrease_value)
	else:
		_speed_descrease_value = 0.0
	
	if new_velocity:
		velocity.x = new_velocity.x
		velocity.z = new_velocity.z
	else:
		velocity.x = lerp(velocity.x, new_velocity.x, delta * 10)
		velocity.z = lerp(velocity.z, new_velocity.z, delta * 10)
	
	update_velocity()
	

func update_gravity(delta : float) -> void:
	velocity.y -= gravity * delta * _gravity_scale
	
	if (is_on_floor() || is_next_to_wall()) && _gravity_scale != default_gravity_scale:
		_gravity_scale = default_gravity_scale
	else:
		_gravity_scale = lerpf(_gravity_scale, default_gravity_scale*2, delta*3)
	

func update_velocity() -> void:
	if is_on_floor():
		apply_floor_snap()
		coyote_timer.start()
	move_and_slide()
	

func get_wall_normal_failsafe() -> Vector3:
	if left_wall_check_shapecast.is_colliding():
		return left_wall_check_shapecast.get_collision_normal(0)
	elif right_wall_check_shapecast.is_colliding():
		return right_wall_check_shapecast.get_collision_normal(0)
	return Vector3.ZERO
	

func get_wish_direction() -> Vector3:
	return (global_transform.basis * head.transform.basis * input_handler.movement_vector).normalized()
	

func get_slope_direction() -> Vector3:
	return get_floor_normal().cross(get_floor_normal().cross(Vector3.UP)).normalized()
	

func can_slide() -> bool:
	if !slope_check_shapecast.is_colliding() || slope_check_shapecast.get_collider(0) == null: return false
	return slope_check_shapecast.get_collider(0).is_in_group("surf_slideable_surface") && input_handler.is_control_held && 0.0 < get_floor_angle() && get_floor_angle() < floor_max_angle
	

func can_wallrun() -> bool:
	return is_next_to_wall() && is_on_wall() && wall_run_cooldown_timer.is_stopped() && get_last_slide_collision().get_collider().is_in_group("surf_wallrunable_surface")
	

func is_next_to_wall() -> bool:
	return right_wall_check_shapecast.is_colliding() || left_wall_check_shapecast.is_colliding()
	

func get_horizontal_speed() -> float:
	return (velocity * Vector3(1.0, 0.0, 1.0)).length()
	

func reset_jumps() -> void:
	if jumps_left != jump_count:
		jumps_left = jump_count
	

func reload_dash() -> void:
	if !dash_cooldown_timer.is_stopped():
		dash_cooldown_timer.stop()
	

func _on_jump_cooldown_timer_timeout() -> void:
	reset_jumps()
	print("Jump restored")
	

func _on_dash_cooldown_timer_timeout() -> void:
	print("Dash ready")
	

func _on_damage_handler_health_drained() -> void:
	scene_loader.load_ui_scene(scene_loader.ui_scenes.death_screen, false, true, 0.0)
	

#region Camera Effects
var impact_speed : float
var impact_strength : float 
var saved_vertical_velocity : float

func _camera_impact_effect(delta : float):
	if !impact_effect_enabled: return
	
	if !is_on_floor():
		_camera_min_vertical_angle_increase_value = 20.0
		
		impact_speed = abs(clampf(velocity.y * 0.5, -max_impact_speed, -min_impact_speed))
		impact_strength = clampf(abs(velocity.y) * 0.05, min_impact_strength, max_impact_strength)
		var head_falling_rotation_offset : float = falling_rotation * impact_strength
		
		head.rotation.x = lerpf(head.rotation.x, head_falling_rotation_offset, delta)
	elif is_on_floor():
		_camera_min_vertical_angle_increase_value = 0.0
		
		var head_impact_position_offset : float = impact_rotation * impact_strength
		
		if saved_vertical_velocity > min_speed_required:
			head.rotation.x = lerpf(head.rotation.x, head_impact_position_offset, delta*impact_speed)
		else:
			head.rotation.x = lerpf(head.rotation.x, 0.0, delta*impact_speed)
		
		
	saved_vertical_velocity = abs(velocity.y)
	

func _camera_wallrun_tilt_effect(delta : float):
	if is_next_to_wall():
		if left_wall_check_shapecast.is_colliding() and right_wall_check_shapecast.is_colliding():
			_wallrun_camera_tilt_amount = 0.0
		elif left_wall_check_shapecast.is_colliding():
			_wallrun_camera_tilt_amount = -tilt_amount
		elif right_wall_check_shapecast.is_colliding():
			_wallrun_camera_tilt_amount = tilt_amount
		
		fps_camera.rotation.z = lerpf(fps_camera.rotation.z, _wallrun_camera_tilt_amount, delta*5)
	elif fps_camera.rotation.z != 0.0:
		fps_camera.rotation.z = lerpf(fps_camera.rotation.z, 0.0, delta*5)
		

func _camera_fov_change(delta : float):
	var velocity_clamped : float = clamp(velocity.length(), 0.5, sprint_speed * 2)
	var target_fov : float = base_fov + fov_change * velocity_clamped
	fps_camera.fov = lerp(fps_camera.fov, target_fov, delta * 5.0)
	

func _apply_headbob(delta: float) -> void:
	_t_bob += delta * clampf(velocity.length(), 0.0, 10.0) * float(is_on_floor())
	
	var pos : Vector3 = Vector3.ZERO
	pos.y = sin(_t_bob * bob_frequency) * bob_amplitude * 0.01
	pos.x = cos(_t_bob * bob_frequency/2) * bob_amplitude * 0.01
	
	fps_camera.transform.origin = pos
#endregion
