extends Control

@onready var rich_text_label: RichTextLabel = $HBoxContainer/RichTextLabel

func _process(_delta: float) -> void:
	rich_text_label.text = "[wave] Fragments: " + str(global.player_fragments) + " [/wave]"
	
