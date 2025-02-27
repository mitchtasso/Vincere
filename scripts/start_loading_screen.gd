extends Control

@onready var loading_screen: Control = $"."
@onready var load_time: Timer = $loadTime
@onready var replay_timer: Timer = $"../../replayTimer"
@onready var player: CharacterBody3D = $"../../player"
@onready var menu_music: AudioStreamPlayer = $"../../sounds/menuMusic"
@onready var start_menu: Control = $"../StartMenu"
@onready var startButton: Button = $"../StartMenu/buttons/VBoxContainer/Start"

func _ready() -> void:
	load_time.start()

func _on_load_time_timeout() -> void:
	loading_screen.hide()
	menu_music.volume_db = -5.0
	start_menu.show()
	startButton.grab_focus()
	menu_music.play()
