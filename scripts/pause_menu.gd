extends Control

@onready var pauseMenu: Control = $"."
@onready var startMenu: Control = $"../StartMenu"
@onready var timer: Timer = $"../../gameTime"
@onready var menuButtonSound: AudioStreamPlayer = $"../../sounds/menuButton"
@onready var player: CharacterBody3D = $"../../player"
@onready var world: Node3D = $"../.."

#Menu UI
@onready var pauseButtons: MarginContainer = $buttons
@onready var controlsBG: TextureRect = $bg2
@onready var controlsDiagram: TextureRect = $diagram
@onready var backButton: MarginContainer = $MarginContainer
@onready var pauseFocus: Button = $buttons/VBoxContainer/Resume
@onready var backFocus: Button = $MarginContainer/VBoxContainer/back
@onready var stats: Button = $buttons/VBoxContainer/Stats

@onready var stat_labels: MarginContainer = $statLabels
@onready var stat_labels_2: MarginContainer = $statLabels2
@onready var health: Label = $statLabels/VBoxContainer/Health
@onready var armor: Label = $statLabels/VBoxContainer/Armor
@onready var melee_attack: Label = $"statLabels/VBoxContainer/Melee Attack"
@onready var magic_attack: Label = $"statLabels/VBoxContainer/Magic Attack"
@onready var weapon_type: Label = $"statLabels/VBoxContainer/Weapon Type"
@onready var magic_type: Label = $"statLabels/VBoxContainer/Magic Type"
@onready var tainted_souls: Label = $"statLabels2/VBoxContainer/Tainted Souls"
@onready var demons_slain: Label = $"statLabels2/VBoxContainer/Demons Slain"
@onready var nights: Label = $statLabels2/VBoxContainer/Nights
@onready var templar: TextureRect = $templar
@onready var icons: MarginContainer = $icons

@onready var loading_screen: Control = $"../LoadingScreen"
@onready var load_time: Timer = $"../LoadingScreen/loadTime"
@onready var replayTimer: Timer = $"../../replayTimer"

func _on_resume_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	menuButtonSound.play()
	get_tree().paused = false
	startMenu.menuActive = false
	pauseMenu.hide()
	timer.start()

func _on_load_last_save_pressed() -> void:
	menuButtonSound.play()
	player.load_data()
	player.gameTimeSec = player.gameTimeSecDef
	player.gameTimeMin = player.gameTimeMinDef
	pauseMenu.hide()
	startMenu.menuActive = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	replayTimer.start()
	timer.start()
	loading_screen.show()
	load_time.start()

func _on_menu_pressed() -> void:
	menuButtonSound.play()
	get_tree().reload_current_scene()

func _on_stats_pressed() -> void:
	menuButtonSound.play()
	pauseButtons.hide()
	controlsBG.show()
	
	health.text = "Health: " + str(player.HEALTH) + "/" + "100"
	armor.text = "Armor: " + str(player.ARMOR) + "/" + "50"
	melee_attack.text = "Melee Attack: " + str(player.playerAttack)
	magic_attack.text = "Magic Attack: " + str(player.playerMagicAtk)
	
	if player.UPGRADE == 0:
		weapon_type.text = "Weapon: SHORTSWORD"
	else:
		weapon_type.text = "Weapon: LONGSWORD"
	
	if player.SPELL == 0:
		magic_type.text = "Magic: None"
	else:
		magic_type.text = "Magic: Fireball"
	
	tainted_souls.text = "Tainted Souls: " + str(player.souls)
	demons_slain.text = "Demons Slain: " + str(player.points)
	nights.text = "Nights Survived: " + str(world.wave - 1)
	
	icons.show()
	templar.show()
	stat_labels.show()
	stat_labels_2.show()
	backButton.show()
	backFocus.grab_focus()

func _on_controls_pressed() -> void:
	menuButtonSound.play()
	pauseButtons.hide()
	controlsBG.show()
	controlsDiagram.show()
	backButton.show()
	backFocus.grab_focus()

func _on_back_pressed() -> void:
	menuButtonSound.play()
	pauseButtons.show()
	controlsBG.hide()
	controlsDiagram.hide()
	stat_labels.hide()
	stat_labels_2.hide()
	backButton.hide()
	templar.hide()
	icons.hide()
	pauseFocus.grab_focus()
