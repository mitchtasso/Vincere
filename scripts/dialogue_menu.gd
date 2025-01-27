extends Control

@onready var title: Label = $title/Title
@onready var dialogLabel: Label = $dialog
@onready var shop_menu: Control = $"../ShopMenu"
@onready var start_menu: Control = $"../StartMenu"
@onready var dialogue_menu: Control = $"."
@onready var menu_button: AudioStreamPlayer = $"../../sounds/menuButton"
@onready var shopFocus: Button = $"../ShopMenu/buttons/VBoxContainer/Yes"

@onready var text_1: Button = $dialogueButtons/VBoxContainer/text1
@onready var text_2: Button = $dialogueButtons/VBoxContainer/text2
@onready var text_3: Button = $dialogueButtons/VBoxContainer/text3
@onready var text_4: Button = $dialogueButtons/VBoxContainer/text4

@onready var dialogue: AudioStreamPlayer = $"../../sounds/dialogue"
@onready var player: CharacterBody3D = $"../../player"
@onready var dialoguePic: TextureRect = $templar

var templarPic = load("res://assets/menu/templarPic.png")
var clericPic = load("res://assets/menu/cleric.png")

var NPC: Array = ["Mercator", "Medicus", "Cleric"]
var activeNPC: String

var dialogueCounter: int  = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	if activeNPC == NPC[0]:
		title.text = "Mercator, the Merchant"
		dialoguePic.texture = templarPic
	elif activeNPC == NPC[1]:
		title.text = "Medicus, the Healer"
		dialoguePic.texture = templarPic
	elif activeNPC == NPC[2]:
		title.text = "Unknown Cleric"
		dialoguePic.texture = clericPic
	
	if activeNPC == NPC[0]:
		if dialogueCounter == 0:
			dialogue.play()
			dialogLabel.text = "Greetings Knight, how may I be of service?"
			text_1.text = "Who are you?"
			text_2.text = "Can I look at your wares?"
			text_3.text = "What is this place?"
			text_4.text = "Farewell."
			dialogueCounter = 1
	if activeNPC == NPC[1]:
		if dialogueCounter == 0:
			dialogue.play()
			dialogLabel.text = "Greetings Knight, how may I be of service?"
			text_1.text = "Who are you?"
			text_2.text = "Heal me please, I am injured."
			text_3.text = "Where do you get your power from?"
			text_4.text = "Farewell."
			dialogueCounter = 1
	if activeNPC == NPC[2]:
		if dialogueCounter == 0:
			dialogue.play()
			dialogLabel.text = "Fateful knight, pleased to make your acquaintance."
			text_1.text = "Who are you?"
			text_2.text = "Fateful? What makes me fateful?"
			text_3.text = "What information do you possess?"
			text_4.text = "Farewell."
			dialogueCounter = 1

func _on_text_1_pressed() -> void:
	dialogue.play()
	if activeNPC == NPC[0]:
		dialogLabel.text = "I am Mercator, a merchant and knight of the Church."
	if activeNPC == NPC[1]:
		dialogLabel.text = "I am Medicus, a healer and knight of the Church."
		dialogLabel.set("theme_override_colors/font_color", Color(255, 255, 255))
	if activeNPC == NPC[2]:
		dialogLabel.text = "I am a wandering cleric, my name is of no importance."
		dialogLabel.set("theme_override_colors/font_color", Color(255, 255, 255))

func _on_text_2_pressed() -> void:
	dialogue.play()
	if activeNPC == NPC[0]:
		dialogue_menu.hide()
		shop_menu.show()
		shopFocus.grab_focus()
	if activeNPC == NPC[1]:
		if player.souls >= 500:
			if player.HEALTH < 100:
				dialogLabel.text = "You are healed. This has consumed 500 tainted souls."
				dialogLabel.set("theme_override_colors/font_color", Color(0, 255, 0))
				player.HEALTH += 100
				player.souls -= 500
			else:
				dialogLabel.text = "You seem to be in perfect health."
				dialogLabel.set("theme_override_colors/font_color", Color(255, 255, 255))
		else:
			dialogLabel.text = "Unfortunately, you do not have enought tainted souls."
			dialogLabel.set("theme_override_colors/font_color", Color(255, 255, 255))
	if activeNPC == NPC[2]:
		dialogLabel.text = "You are fated to rid this land of the demonic presence."

func _on_text_3_pressed() -> void:
	dialogue.play()
	if activeNPC == NPC[0]:
		dialogLabel.text = "This is the Church of Redemption, closed due to demon presence."
	if activeNPC == NPC[1]:
		dialogLabel.text = "The same power the Church uses to cleanse tainted souls is used to heal you."
		dialogLabel.set("theme_override_colors/font_color", Color(255, 255, 255))
	if activeNPC == NPC[2]:
		dialogLabel.text = "On the 11th night of your struggle, the demon commander will show himself."

func _on_text_4_pressed() -> void:
	dialogLabel.set("theme_override_colors/font_color", Color(255, 255, 255))
	dialogueCounter = 0
	dialogue_menu.hide()
	menu_button.play()
	get_tree().paused = false
	start_menu.menuActive = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
