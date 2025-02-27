extends Control

@onready var startMenu: Control = $"../StartMenu"
@onready var deathMenu: Control = $"."
@onready var timer: Timer = $"../../gameTime"
@onready var player: CharacterBody3D = $"../../player"
@onready var replayTimer: Timer = $"../../replayTimer"
@onready var menuButtonSound: AudioStreamPlayer = $"../../sounds/menuButton"
@onready var H_killsLabel: Label = $buttons/VBoxContainer/H_kills
@onready var H_timeLabel: Label = $buttons/VBoxContainer/H_time
@onready var killsLabel: Label = $buttons/VBoxContainer/kills
@onready var timeLabel: Label = $buttons/VBoxContainer/time

func _physics_process(_delta: float) -> void:
	
	var time_string1 = "%02d:%02d" % [player.gameTimeMin, player.gameTimeSec]
	killsLabel.text = "Demons Slain: " + str(player.points)
	timeLabel.text = "Time Survived: " + time_string1
	
	var time_string = "%02d:%02d" % [player.playerData.gameTimeMin, player.playerData.gameTimeSec]
	H_killsLabel.text = "Demons Slain: " + str(player.playerData.kills)
	H_timeLabel.text = "Time Survived: " + time_string

func _on_replay_pressed() -> void:
	deathMenu.hide()
	menuButtonSound.play()
	get_tree().paused = false
	startMenu.menuActive = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	replayTimer.start()
	player.stat_reset()
	timer.start()

func _on_menu_pressed() -> void:
	menuButtonSound.play()
	get_tree().reload_current_scene()
