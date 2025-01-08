extends Control

@onready var startMenu = $"../StartMenu"
@onready var deathMenu = $"."
@onready var timer = $"../../gameTime"
@onready var player = $"../../player"
@onready var replayTimer = $"../../replayTimer"
@onready var menuButtonSound = $"../../sounds/menuButton"

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
