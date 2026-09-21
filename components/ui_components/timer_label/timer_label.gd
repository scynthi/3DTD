extends Control

@export var rich_prefix : String
@export var timer : Timer

@onready var rich_text_label: RichTextLabel = $RichTextLabel

func _ready() -> void:
	rich_text_label.text = rich_prefix + str(timer.wait_time)

func _process(_delta: float) -> void:
	rich_text_label.text = rich_prefix + str(timer.time_left)
	
