extends Control

@onready var startMenu: Control = $"../StartMenu"
@onready var continueMenu: Control = $"."
@onready var timer: Timer = $"../../gameTime"
@onready var player: CharacterBody3D = $"../../player"
@onready var replayTimer: Timer = $"../../replayTimer"
@onready var menuButtonSound: AudioStreamPlayer = $"../../sounds/menuButton"
@onready var world: Node3D = $"../.."

@onready var wave_label: Label = $"../waveUI/VBoxContainer/waveLabel"
@onready var time_label: Label = $"../waveUI/VBoxContainer/time"

@onready var shop: Node3D = $"../../Shop"
@onready var graveyard: NavigationRegion3D = $"../../NavigationRegion3D"
@onready var graveyard_other_textures: Node3D = $"../../OtherTextures"
@onready var all_enemies: Node3D = $"../../allEnemies"

@onready var loading_screen: Control = $"../LoadingScreen"
@onready var load_time: Timer = $"../LoadingScreen/loadTime"

func _on_yes_pressed() -> void:
	if world.wave <= 10:
		continueMenu.hide()
		menuButtonSound.play()
		startMenu.menuActive = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		replayTimer.start()
		timer.start()
		loading_screen.show()
		load_time.start()
		player.new_wave()
	else:
		menuButtonSound.play()
		continueMenu.hide()
		player.new_wave()

func _on_no_pressed() -> void:
	menuButtonSound.play()
	continueMenu.hide()
	menuButtonSound.play()
	get_tree().paused = false
	startMenu.menuActive = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
