extends Control

@onready var uiOptions = $buttons/VBoxContainer/controls
@onready var menuButtonSound = $"../../sounds/menuButton"

@onready var StartMenu = $"../StartMenu"
@onready var StartMenuSelect = $"../StartMenu/buttons/VBoxContainer/Start"

@onready var OptionMenu = $"."

@onready var ControlsMenu = $"../ControlsMenu"
@onready var ControlMenuSelect = $"../ControlsMenu/MarginContainer/VBoxContainer/back"

@onready var AudioMenu = $"../AudioMenu"
@onready var AudioMenuSelect = $"../AudioMenu/MarginContainer/VBoxContainer/back"

@onready var VideoMenu = $"../VideoMenu"
@onready var VideoMenuSelect = $"../VideoMenu/MarginContainer/VBoxContainer/back"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	uiOptions.grab_focus()

func _on_controls_pressed() -> void:
	menuButtonSound.play()
	OptionMenu.hide()
	ControlsMenu.show()
	ControlMenuSelect.grab_focus()

func _on_video_pressed() -> void:
	menuButtonSound.play()
	OptionMenu.hide()
	VideoMenu.show()
	VideoMenu.load_data()
	VideoMenuSelect.grab_focus()

func _on_audio_pressed() -> void:
	menuButtonSound.play()
	OptionMenu.hide()
	AudioMenu.show()
	AudioMenu.load_data()
	AudioMenuSelect.grab_focus()

func _on_back_pressed() -> void:
	menuButtonSound.play()
	OptionMenu.hide()
	StartMenu.show()
	StartMenuSelect.grab_focus()
	
