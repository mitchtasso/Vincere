extends Control

@onready var loading_screen: Control = $"."
@onready var load_time: Timer = $loadTime
@onready var replay_timer: Timer = $"../../replayTimer"
@onready var player: CharacterBody3D = $"../../player"
@onready var menu_music: AudioStreamPlayer = $"../../sounds/menuMusic"
@onready var story_menu: Control = $"../StoryMenu"

func _ready() -> void:
	load_time.start()

func _on_load_time_timeout() -> void:
	loading_screen.hide()
	menu_music.volume_db = -12.5
	story_menu.show()
	menu_music.play()
