extends Control


@onready var progress_bar: ProgressBar = $TowerHealth/MarginContainer/HBoxContainer/VBoxContainer/ProgressBar
@onready var rich_text_label: RichTextLabel = $TowerHealth/MarginContainer/FragmentsUI/RichTextLabel
@onready var wave_label: Label = $TowerHealth/MarginContainer/WaveUI/WaveLabel

func _ready() -> void:
	progress_bar.max_value = global.nexus.health_component.max_health
	global.nexus.health_component.died.connect(func(): progress_bar.value = 0)

func _process(_delta: float) -> void:
	wave_label.text = "Wave: " + str(global.current_wave) + "/" + str(global.last_wave)
	rich_text_label.text = "[wave]Fragments:\n" + str(global.player.fragments) + "[/wave]"
	
	if global.nexus: progress_bar.value = global.nexus.health_component.current_health
	
