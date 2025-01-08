extends Control

@onready var ControlsMenu = $"."
@onready var buttonSound = $"../../sounds/menuButton"

@onready var OptionsMenu = $"../OptionsMenu"
@onready var OptionsMenuSelect = $"../OptionsMenu/buttons/VBoxContainer/controls"

func _on_back_pressed():
	buttonSound.play()
	ControlsMenu.hide()
	OptionsMenu.show()
	OptionsMenuSelect.grab_focus()
