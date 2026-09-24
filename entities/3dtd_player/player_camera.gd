extends Camera3D

@onready var player_ui: PlayerUI = $UI/PlayerUI

const BASIC_TOWER_SCENE = preload("res://entities/towers/basic/basic_tower.tscn")

func _ready() -> void:
	player_ui.disable_crosshair_position_calculation = true
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	

func _process(_delta: float) -> void:
	player_ui._cross_hair_position = get_viewport().get_mouse_position()
	

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("left_click"):
		project_raycast_from_mouse_position()
	

func project_raycast_from_mouse_position() -> void:
	var mouse_pos : Vector2 = get_viewport().get_mouse_position()
	var ray_length : int = 1000
	var from : Vector3 = self.project_ray_origin(mouse_pos)
	var to : Vector3 = from + self.project_ray_normal(mouse_pos) * ray_length
	var space := get_world_3d().direct_space_state
	var ray_query := PhysicsRayQueryParameters3D.new()
	
	ray_query.from = from
	ray_query.to = to
	ray_query.collide_with_areas = true
	ray_query.collide_with_bodies = true
	
	var result_dict := space.intersect_ray(ray_query)
	if len(result_dict) == 0: return
	
	
	
	if result_dict["collider"] is Platform:
		var platform : Platform = result_dict["collider"]
		
		if !platform.is_enabled or platform.has_tower: return
		
		place_tower(result_dict["collider"] as Platform)
		
	

func place_tower(platform : Platform) -> void:
	var tower_instance : BasicTower = BASIC_TOWER_SCENE.instantiate()
	
	get_tree().current_scene.add_child(tower_instance)
	tower_instance.global_position = platform.global_position
	
	
	
