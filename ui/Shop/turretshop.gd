class_name TurretShop extends Control

@onready var button: Button = $VBoxContainer/Turret1Cont/Button
@onready var lista: Array [HBoxContainer] = [$VBoxContainer/Turret1Cont, $VBoxContainer/Turret2Cont, $VBoxContainer/Turret3Cont]

func ShowTurrets(level : int) -> void:
	for i in range(0, level):
		lista[i].hide()


func _on_basis_turret_button_pressed() -> void:
	global.player.bought_towers["simple"]+=1
	queue_free()


func _on_advanced_turret_button_pressed() -> void:
	global.player.bought_towers["advanced"]+=1
	queue_free()


func _on_maxed_turret_button_pressed() -> void:
	global.player.bought_towers["maxed"]+=1
	queue_free()
