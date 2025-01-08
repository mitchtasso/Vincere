extends Control

@onready var loading_screen: Control = $"."
@onready var load_time: Timer = $loadTime
@onready var replay_timer: Timer = $"../../replayTimer"
@onready var player: CharacterBody3D = $"../../player"

func _on_load_time_timeout() -> void:
	loading_screen.hide()
	get_tree().paused = false
	player.playerDeath = true
	replay_timer.start()
