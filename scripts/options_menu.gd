extends Control

@onready var uiOptions: Button = $buttons/VBoxContainer/controls
@onready var menuButtonSound: AudioStreamPlayer = $"../../sounds/menuButton"

@onready var StartMenu: Control = $"../StartMenu"
@onready var StartMenuSelect: Button = $"../StartMenu/buttons/VBoxContainer/Start"

@onready var OptionMenu: Control = $"."

@onready var ControlsMenu: Control = $"../ControlsMenu"
@onready var ControlMenuSelect: Button = $"../ControlsMenu/MarginContainer/VBoxContainer/back"

@onready var AudioMenu: Control = $"../AudioMenu"
@onready var AudioMenuSelect: Button = $"../AudioMenu/MarginContainer/VBoxContainer/back"

@onready var VideoMenu: Control = $"../VideoMenu"
@onready var VideoMenuSelect: Button = $"../VideoMenu/MarginContainer/VBoxContainer/back"

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
	
