extends Control

@onready var credit_screen: Control = $"."

func _on_button_pressed() -> void:
	get_tree().reload_current_scene()
