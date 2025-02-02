extends Control

@onready var title: Label = $title/Title
@onready var dialogLabel: Label = $dialog
@onready var shop_menu: Control = $"../ShopMenu"
@onready var start_menu: Control = $"../StartMenu"
@onready var dialogue_menu: Control = $"."
@onready var menu_button: AudioStreamPlayer = $"../../sounds/menuButton"
@onready var shopFocus: Button = $"../ShopMenu/buttons/VBoxContainer/Yes"
@onready var world: Node3D = $"../.."
@onready var credit_screen: Control = $"../CreditScreen"
@onready var credit_focus: Button = $"../CreditScreen/MarginContainer2/VBoxContainer/Button"
@onready var heal_sound: AudioStreamPlayer = $"../../sounds/healSound"

@onready var text_1: Button = $dialogueButtons/VBoxContainer/text1
@onready var text_2: Button = $dialogueButtons/VBoxContainer/text2
@onready var text_3: Button = $dialogueButtons/VBoxContainer/text3
@onready var text_4: Button = $dialogueButtons/VBoxContainer/text4

@onready var dialogue: AudioStreamPlayer = $"../../sounds/dialogue"
@onready var player: CharacterBody3D = $"../../player"
@onready var dialoguePic: TextureRect = $templar

var templarPic = load("res://assets/menu/templarPic.png")
var clericPic = load("res://assets/menu/cleric.png")

var NPC: Array = ["Mercator", "Medicus", "Cleric", "Cappellanus"]
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
	elif activeNPC == NPC[3]:
		title.text = "Cappellanus"
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
	if activeNPC == NPC[3]:
		if dialogueCounter == 0:
			dialogue.play()
			dialogLabel.text = "Fateful knight, you have vanquished the demons of this land."
			text_1.text = "What happens now?"
			text_2.text = "Who are you really?"
			text_3.text = "Are there any more?"
			text_4.text = "Let us depart. (GAME END)"
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
	if activeNPC == NPC[3]:
		dialogLabel.text = "Your quest has just begun, you must hunt these demonic sites."
		dialogLabel.set("theme_override_colors/font_color", Color(255, 255, 255))

func _on_text_2_pressed() -> void:
	if activeNPC == NPC[0]:
		dialogue.play()
		dialogue_menu.hide()
		shop_menu.show()
		shopFocus.grab_focus()
	if activeNPC == NPC[1]:
		if player.souls >= 500:
			if player.HEALTH < 100:
				heal_sound.play()
				dialogLabel.text = "You are healed. This has consumed 500 tainted souls."
				dialogLabel.set("theme_override_colors/font_color", Color(0, 255, 0))
				player.HEALTH += 100
				player.souls -= 500
			else:
				dialogue.play()
				dialogLabel.text = "You seem to be in perfect health."
				dialogLabel.set("theme_override_colors/font_color", Color(255, 255, 255))
		else:
			dialogue.play()
			dialogLabel.text = "Unfortunately, you do not have enought tainted souls."
			dialogLabel.set("theme_override_colors/font_color", Color(255, 255, 255))
	if activeNPC == NPC[2]:
		dialogue.play()
		dialogLabel.text = "You are fated to rid this land of the demonic presence."
	if activeNPC == NPC[3]:
		dialogue.play()
		dialogLabel.text = "I am Cappellanus, a cleric and knight of the Holy See."

func _on_text_3_pressed() -> void:
	dialogue.play()
	if activeNPC == NPC[0]:
		dialogLabel.text = "This is the Church of Redemption, closed due to demon presence."
	if activeNPC == NPC[1]:
		dialogLabel.text = "The same power the Church uses to cleanse tainted souls is used to heal you."
		dialogLabel.set("theme_override_colors/font_color", Color(255, 255, 255))
	if activeNPC == NPC[2]:
		dialogLabel.text = "On the 11th night of your struggle, the demon commander will show himself."
	if activeNPC == NPC[3]:
		dialogLabel.text = "It appears that the death of the demon commander has halted them, for now."

func _on_text_4_pressed() -> void:
	if world.gameEnd == false:
		dialogLabel.set("theme_override_colors/font_color", Color(255, 255, 255))
		dialogueCounter = 0
		dialogue_menu.hide()
		menu_button.play()
		get_tree().paused = false
		start_menu.menuActive = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		dialogue_menu.hide()
		credit_screen.show()
		credit_focus.grab_focus()
		menu_button.play()
	
