class_name LoadingScreen extends Control

@onready var progress_bar: ProgressBar = $HBoxContainer/VBoxContainer/ProgressBar

func _process(_delta: float) -> void:
	progress_bar.value = scene_loader.progress[0]*100
