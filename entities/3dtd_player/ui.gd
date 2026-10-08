extends Control

@onready var rich_text_label: RichTextLabel = $FragmentsUI/RichTextLabel
@onready var progress_bar: ProgressBar = $TowerHealth/MarginContainer/HBoxContainer/VBoxContainer/ProgressBar

func _ready() -> void:
	progress_bar.max_value = global.nexus.health_component.max_health
	

func _process(_delta: float) -> void:
	rich_text_label.text = "[wave] Fragments: " + str(global.player.fragments) + " [/wave]"
	
	if progress_bar.value > 0.0:
		if global.nexus: progress_bar.value = global.nexus.health_component.current_health
		else: progress_bar.value = 0
		
	
