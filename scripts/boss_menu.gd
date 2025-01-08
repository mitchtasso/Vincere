extends Control

@onready var boss_menu: Control = $"."
@onready var menu_button: AudioStreamPlayer = $"../../sounds/menuButton"
@onready var start_menu: Control = $"../StartMenu"
@onready var replay_timer: Timer = $"../../replayTimer"

func _on_continue_pressed() -> void:
	menu_button.play()
	boss_menu.hide()
	start_menu.menuActive = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	replay_timer.start()
