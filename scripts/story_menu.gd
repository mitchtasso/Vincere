extends Control
@onready var story_menu: Control = $"."
@onready var menu_music: AudioStreamPlayer = $"../../sounds/menuMusic"
@onready var menu_button: AudioStreamPlayer = $"../../sounds/menuButton"
@onready var start_menu: Control = $"../StartMenu"
@onready var game_time: Timer = $"../../gameTime"
@onready var player: CharacterBody3D = $"../../player"
@onready var loading_screen: Control = $"../LoadingScreen"
@onready var load_time: Timer = $"../LoadingScreen/loadTime"
@onready var storyLabel: Label = $Label
@onready var controlDiagram: TextureRect = $TextureRect
@onready var warningLabel: Label = $Label2

var turn: int = 0

func _process(_delta: float) -> void:
	if player.playerData.wave > 1 and turn == 0:
		storyLabel.hide()
		warningLabel.show()

func _on_continue_pressed() -> void:
	if turn == 0:
		menu_button.play()
		storyLabel.show()
		warningLabel.hide()
		turn = 1
	elif turn == 1:
		menu_button.play()
		storyLabel.hide()
		controlDiagram.show()
		turn = 2
	else:
		story_menu.hide()
		menu_music.stop()
		menu_button.play()
		start_menu.menuActive = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		game_time.start()
		player.stat_reset()
		loading_screen.show()
		load_time.start()

func _on_back_pressed() -> void:
	get_tree().reload_current_scene()
