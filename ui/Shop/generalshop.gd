class_name GeneralShop extends Control

@onready var damage_button: Button = $VBoxContainer/DamageContainer/damageButton
var damage_Level : int = 0
var damage_Price : int = 10

@onready var attack_speed_button: Button = $VBoxContainer/AttackSpeedContainer/attackSpeedButton
var attackspeed_Level : int = 0
var attackspeed_Price : int = 10

@onready var attack_range_button: Button = $VBoxContainer/AttackRangeContainer/attackRangeButton
var attackrange_Level : int = 0
var attackrange_Price : int = 10




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_damage_button_pressed() -> void:
	if(damage_Price<global.player.fragments):
		global.player.fragments-=damage_Price
		damage_Level+=1
		damage_Price = 10+damage_Level
		damage_button.text = str(damage_Price)
	
	


func _on_attack_speed_button_pressed() -> void:
	pass # Replace with function body.
