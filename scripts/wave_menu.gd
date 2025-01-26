extends Control

@onready var startMenu: Control = $"../StartMenu"
@onready var waveMenu: Control = $"."
@onready var timer: Timer = $"../../gameTime"
@onready var player: CharacterBody3D = $"../../player"
@onready var replayTimer: Timer = $"../../replayTimer"
@onready var menuButtonSound: AudioStreamPlayer = $"../../sounds/menuButton"
@onready var loading_screen: Control = $"../LoadingScreen"
@onready var load_time: Timer = $"../LoadingScreen/loadTime"
@onready var shop_music: AudioStreamPlayer = $"../../sounds/shopMusic"


func _on_continue_pressed() -> void:
	waveMenu.hide()
	menuButtonSound.play()
	startMenu.menuActive = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	loading_screen.show()
	load_time.start()

func _on_menu_pressed() -> void:
	menuButtonSound.play()
	get_tree().reload_current_scene()
