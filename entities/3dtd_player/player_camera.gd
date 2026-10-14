class_name SpectatorPlayerCamera extends Camera3D

@onready var player_ui: PlayerUI = $UI/PlayerUI
@onready var default_position : Vector3 = self.global_position

var bought_towers : Dictionary[String, int] = {"simple":0, "advanced":0, "maxed":0}
var fragments : int = 999999999 if global.infinite_fragment else 70
var is_camera_focused : bool = false
var current_platform : Platform = null

const BASIC_TOWER_SCENE : PackedScene = preload("res://entities/towers/basic/basic_tower.tscn")
const ADVANCED_TOWER_SCENE : PackedScene = preload("res://entities/towers/advanced/advanced_tower.tscn")
const MAXED_TOWER_SCENE : PackedScene = preload("res://entities/towers/maxed/maxed_tower.tscn")
const TOWER_SHOP : PackedScene = preload("res://ui/Shop/turretshop.tscn")


func _init() -> void:
	global.player = self
	

func _ready() -> void:
	player_ui.disable_crosshair_position_calculation = true
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	

func _process(_delta: float) -> void:
	player_ui._cross_hair_position = get_viewport().get_mouse_position()
	

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("left_click"):
		project_raycast_from_mouse_position()
	

func project_raycast_from_mouse_position() -> void:
	if current_platform || is_camera_focused: return
	
	var mouse_pos : Vector2 = get_viewport().get_mouse_position()
	var ray_length : int = 1000
	var from : Vector3 = self.project_ray_origin(mouse_pos)
	var to : Vector3 = from + self.project_ray_normal(mouse_pos) * ray_length
	var space := get_world_3d().direct_space_state
	var ray_query := PhysicsRayQueryParameters3D.new()
	
	ray_query.from = from
	ray_query.to = to
	ray_query.collide_with_areas = false
	ray_query.collide_with_bodies = true
	
	var result_dict := space.intersect_ray(ray_query)
	
	if len(result_dict) == 0: return
	
	var result : Node3D = result_dict["collider"]
	
	if result is Platform:
		current_platform = result_dict["collider"]
		
		if !current_platform.is_enabled: 
			current_platform = null
			return
		
		focus_on_platform(current_platform)
		
	

func open_turret_shop() -> void:
	var tower_ui : TurretShop = TOWER_SHOP.instantiate()
	get_tree().current_scene.add_child(tower_ui)
	tower_ui.position = ( get_viewport().get_visible_rect().size + tower_ui.size ) / 2 - Vector2(40, 40)
	tower_ui.ShowTurrets(current_platform.tower_level)
	

func reset_camera_focus() -> void:
	global_position = default_position
	is_camera_focused = false
	current_platform = null
	

func focus_on_platform(platform : Platform) -> void:
	var new_position : Vector3 = platform.global_position - Vector3(5, -5, 0)
	
	global_position = new_position
	is_camera_focused = true
	
	open_turret_shop()
	

func place_tower() -> void:
	var tower_instance : Tower = null
	
	if (bought_towers["simple"] > 0):
		tower_instance = BASIC_TOWER_SCENE.instantiate()
		bought_towers["simple"] -= 1
	elif (bought_towers["advanced"] > 0):
		tower_instance = ADVANCED_TOWER_SCENE.instantiate()
		bought_towers["advanced"] -= 1
	elif (bought_towers["maxed"] > 0):
		tower_instance = MAXED_TOWER_SCENE.instantiate()
		bought_towers["maxed"] -= 1
	else: return
	
	get_tree().current_scene.add_child(tower_instance)
	tower_instance.global_position = current_platform.global_position
	current_platform.set_tower_level(tower_instance)
	current_platform = null
	
