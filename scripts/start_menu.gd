extends Control

@onready var startMenu = $"."
@onready var timer = $"../../gameTime"
@onready var uiOptions = $buttons/VBoxContainer/Start
@onready var OptionMenuSelect = $"../OptionsMenu/buttons/VBoxContainer/controls"
@onready var menuMusic = $"../../sounds/menuMusic"
@onready var menuButtonSound = $"../../sounds/menuButton"
@onready var OptionMenu = $"../OptionsMenu"
@onready var player: CharacterBody3D = $"../../player"
@onready var story_menu: Control = $"../storyMenu"
@onready var storyMenuSelect: Button = $"../storyMenu/continuebutton/VBoxContainer/Continue"
@onready var loading_screen: Control = $"../LoadingScreen"
@onready var load_time: Timer = $"../LoadingScreen/loadTime"

var menuActive = true

func _process(_delta):
	if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion and menuActive == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	menuMusic.play()
	get_tree().paused = true
	uiOptions.grab_focus()

func _on_start_pressed() -> void:
	startMenu.hide()
	menuMusic.stop()
	menuButtonSound.play()
	startMenu.hide()
	story_menu.show()
	storyMenuSelect.grab_focus()

func _on_load_game_pressed() -> void:
	startMenu.hide()
	menuMusic.stop()
	menuButtonSound.play()
	menuActive = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	loading_screen.show()
	load_time.start()
	timer.start()

func _on_options_pressed() -> void:
	menuButtonSound.play()
	startMenu.hide()
	OptionMenu.show()
	OptionMenuSelect.grab_focus()

func _on_exit_pressed() -> void:
	get_tree().quit()
