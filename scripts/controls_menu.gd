extends Control

@onready var ControlsMenu: Control = $"."
@onready var buttonSound: AudioStreamPlayer = $"../../sounds/menuButton"

@onready var OptionsMenu: Control = $"../OptionsMenu"
@onready var OptionsMenuSelect: Button = $"../OptionsMenu/buttons/VBoxContainer/controls"

func _on_back_pressed():
	buttonSound.play()
	ControlsMenu.hide()
	OptionsMenu.show()
	OptionsMenuSelect.grab_focus()
