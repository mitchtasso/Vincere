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

@onready var startCamera: Camera3D = $"../../MenuArea/StartCamera"
@onready var stats_ui: Control = $"../statsUI"
@onready var player_ui: MarginContainer = $"../playerUI"
@onready var wave_ui: MarginContainer = $"../waveUI"
@onready var crosshair: MarginContainer = $"../crosshair"
@onready var sun: DirectionalLight3D = $"../../sun"
@onready var menu_area: Node3D = $"../../MenuArea"

var menuActive = true
var startMenuActive = true

func _process(_delta):
	if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if startMenuActive == true:
		sun.light_energy = 0.05

func _input(event):
	if event is InputEventMouseMotion and menuActive == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _ready():
	startCamera.make_current()
	stats_ui.hide()
	player_ui.hide()
	wave_ui.hide()
	crosshair.hide()
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	menuMusic.play()
	get_tree().paused = true
	uiOptions.grab_focus()

func _on_start_pressed() -> void:
	startCamera.clear_current()
	menu_area.hide()
	stats_ui.show()
	player_ui.show()
	wave_ui.show()
	crosshair.show()
	startMenuActive = false
	
	startMenu.hide()
	menuMusic.stop()
	menuButtonSound.play()
	startMenu.hide()
	story_menu.show()
	storyMenuSelect.grab_focus()

func _on_load_game_pressed() -> void:
	startCamera.clear_current()
	menu_area.hide()
	stats_ui.show()
	player_ui.show()
	wave_ui.show()
	crosshair.show()
	startMenuActive = false
	
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
