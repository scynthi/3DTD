class_name TurretShop extends Control

@onready var lista: Array [HBoxContainer] = [$VBoxContainer/Turret1Cont, $VBoxContainer/Turret2Cont, $VBoxContainer/Turret3Cont]

func ShowTurrets(level : int) -> void:
	for i in range(0, level):
		lista[i].hide()
	

func _on_basis_turret_button_pressed() -> void:
	if(global.player.fragments >= 10):
		global.player.fragments -= 10
		global.player.bought_towers["simple"]+=1
		global.player.place_tower()
		close_menu()
	

func _on_advanced_turret_button_pressed() -> void:
	if(global.player.fragments >= 50):
		global.player.fragments -= 50
		global.player.bought_towers["advanced"]+=1
		global.player.place_tower()
		close_menu()
	

func _on_maxed_turret_button_pressed() -> void:
	if(global.player.fragments >= 90):
		global.player.fragments -= 90
		global.player.bought_towers["maxed"]+=1
		global.player.place_tower()
		close_menu()
		
	

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("esc"):
		global.player.current_platform = null
		close_menu()
	

func close_menu() -> void:
	global.player.reset_camera_focus()
	queue_free()
	
