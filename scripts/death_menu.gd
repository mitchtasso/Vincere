extends Control

@onready var startMenu: Control = $"../StartMenu"
@onready var deathMenu: Control = $"."
@onready var timer: Timer = $"../../gameTime"
@onready var player: CharacterBody3D = $"../../player"
@onready var replayTimer: Timer = $"../../replayTimer"
@onready var menuButtonSound: AudioStreamPlayer = $"../../sounds/menuButton"

func _on_replay_pressed() -> void:
	deathMenu.hide()
	menuButtonSound.play()
	get_tree().paused = false
	startMenu.menuActive = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	replayTimer.start()
	timer.start()

func _on_menu_pressed() -> void:
	menuButtonSound.play()
	get_tree().reload_current_scene()
