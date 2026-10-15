class_name GeneralShop extends Control

@onready var damage_button: Button = $VBoxContainer/DamageContainer/damageButton
var damage_Level : int = 0
var damage_Price : int = 10
@onready var damage_label: Label = $VBoxContainer/DamageContainer/DamageLabel

@onready var attack_speed_button: Button = $VBoxContainer/AttackSpeedContainer/attackSpeedButton
var attackspeed_Level : int = 0
var attackspeed_Price : int = 10
@onready var attack_speed_label: Label = $VBoxContainer/AttackSpeedContainer/AttackSpeedLabel
@onready var attack_speed_container: HBoxContainer = $VBoxContainer/AttackSpeedContainer

@onready var attack_range_button: Button = $VBoxContainer/AttackRangeContainer/attackRangeButton
var attackrange_Level : int = 0
var attackrange_Price : int = 10
@onready var attack_range_label: Label = $VBoxContainer/AttackRangeContainer/AttackRangeLabel

@onready var hp_button: Button = $VBoxContainer/HPContainer/HPButton
var hp_Level : int = 0
var hp_Price : int = 10
@onready var hp_label: Label = $VBoxContainer/HPContainer/HPLabel

func _ready() -> void:
	damage_label.text = "Damage\nCurrent "+str(global.tower_data.damage)+"/shots\nNext "+str(global.tower_data.damage+1) + "/shots"
	attack_speed_label.text = "Attack Speed\nCurrent "+str(global.tower_data.attack_speed)+"s\nNext "+str(global.tower_data.attack_speed-0.02)+"s"
	attack_range_label.text = "Attack Range\nCurrent "+str(global.tower_data.detection_range)+"m\nNext "+str(global.tower_data.detection_range+1)+"m"
	hp_label.text = "HP\nCurrent "+str(global.tower_data.detection_range)+"\nNext "+str(global.tower_data.detection_range+1)
	

func _process(_delta: float) -> void:
	global.update_tower_property()


func _on_damage_button_pressed() -> void:
	if(damage_Price<=global.player.fragments):
		global.player.fragments-=damage_Price
		damage_Level+=5
		damage_Price = 10+damage_Level
		damage_button.text = str(damage_Price)
		global.tower_data.damage += 1
		damage_label.text = "Damage\nCurrent "+str(global.tower_data.damage)+"/shots\nNext "+str(global.tower_data.damage+1) + "/shots"


func _on_attack_speed_button_pressed() -> void:
	if(attackspeed_Price<=global.player.fragments):
		global.player.fragments-=attackspeed_Price
		attackspeed_Level+=5
		attackspeed_Price = 10+attackspeed_Level
		attack_speed_button.text = str(attackspeed_Price)
		global.tower_data.attack_speed -= 0.02
		attack_speed_label.text = "Attack Speed\nCurrent "+str(global.tower_data.attack_speed)+"s\nNext "+str(global.tower_data.attack_speed-0.02)+"s"
		if(global.tower_data.attack_speed <= 0.03):
			attack_speed_container.hide()


func _on_attack_range_button_pressed() -> void:
	if(attackrange_Price<=global.player.fragments):
		global.player.fragments-=attackrange_Price
		attackrange_Price+=5
		attack_range_button.text = str(attackrange_Price)
		global.tower_data.detection_range += 1
		attack_range_label.text = "Attack Range\nCurrent "+str(global.tower_data.detection_range)+"m\nNext "+str(global.tower_data.detection_range+1)+"m"


func _on_hp_button_pressed() -> void:
	if(attackrange_Price<=global.player.fragments):
		global.player.fragments-=hp_Price
		hp_Price+=5
		hp_button.text = str(hp_Price)
		global.tower_data.health += 1
		hp_label.text = "HP\nCurrent "+str(global.tower_data.health)+"\nNext "+str(global.tower_data.health+1)
