extends Control

@onready var startMenu: Control = $"../StartMenu"
@onready var shopMenu: Control = $"."
@onready var player: CharacterBody3D = $"../../player"
@onready var menuButtonSound: AudioStreamPlayer = $"../../sounds/menuButton"
@onready var dialogue_menu: Control = $"../DialogueMenu"
@onready var dialogueFocus: Button = $"../DialogueMenu/dialogueButtons/VBoxContainer/text1"

#Item buttons
@onready var armorButton: Button = $itemButtons/VBoxContainer/armor
@onready var spellButton: Button = $itemButtons/VBoxContainer/spell
@onready var sharpenButton: Button = $itemButtons/VBoxContainer/sharpen
@onready var upgradeButton: Button = $itemButtons/VBoxContainer/upgrade


#Item price labels
@onready var armorLabel: Label = $priceLabels/VBoxContainer/armor
@onready var spellLabel: Label = $priceLabels/VBoxContainer/spell
@onready var sharpLabel: Label = $priceLabels/VBoxContainer/sharp
@onready var upgradeLabel: Label = $priceLabels/VBoxContainer/upgrade
@onready var soul_label: Label = $souls/soulLabel
@onready var spell_upgrade_label: Label = $priceLabels/VBoxContainer/spellUpgrade

var armorPrice: int = 1000
var sharpenPrice: int = 3000
var upgradePrice: int = 10000
var armorUpgradePrice: int = 3000

func _process(_delta: float) -> void:
	
	if player.ARMOR < 50:
		armorLabel.text = "-" + str(armorPrice)
		armorLabel.set("theme_override_colors/font_color", Color(255, 255, 255))
	else:
		armorLabel.text = "Full"
		armorLabel.set("theme_override_colors/font_color", Color(0, 255, 0))
	
	if player.playerAttack < 75:
		sharpLabel.text = "-" + str(sharpenPrice)
		sharpLabel.set("theme_override_colors/font_color", Color(255, 255, 255))
	else:
		sharpLabel.text = "Purchased"
		sharpLabel.set("theme_override_colors/font_color", Color(0, 255, 0))
	
	#if player.SPELL == 0:
		#spellLabel.text = "-" + str(spellPrice)
		#spellLabel.set("theme_override_colors/font_color", Color(255, 255, 255))
	#elif player.SPELL == 1:
		#spellLabel.text = "Purchased"
		#spellLabel.set("theme_override_colors/font_color", Color(0, 255, 0))
	
	if player.maxArmor < 100:
		spellLabel.text = "-" + str(armorUpgradePrice)
		spellLabel.set("theme_override_colors/font_color", Color(255, 255, 255))
	else:
		spellLabel.text = "Purchased"
		spellLabel.set("theme_override_colors/font_color", Color(0, 255, 0))
	
	if player.UPGRADE == 0:
		upgradeLabel.text = "-" + str(upgradePrice)
		upgradeLabel.set("theme_override_colors/font_color", Color(255, 255, 255))
	elif player.UPGRADE == 1:
		upgradeLabel.text = "Purchased"
		upgradeLabel.set("theme_override_colors/font_color", Color(0, 255, 0))
	
	soul_label.text = "   : " + str(player.souls)

func _on_yes_pressed() -> void:
	menuButtonSound.play()
	shopMenu.hide()
	dialogue_menu.show()
	dialogueFocus.grab_focus()	

func _on_armor_pressed() -> void:
	menuButtonSound.play()
	if player.souls >= armorPrice and player.ARMOR < 50:
		player.souls -= armorPrice
		player.ARMOR += 50

func _on_spell_pressed() -> void:
	menuButtonSound.play()
	if player.souls >= armorUpgradePrice and player.maxArmor < 100:
		player.souls -= armorUpgradePrice
		player.maxArmor += 10

func _on_sharpen_pressed() -> void:
	menuButtonSound.play()
	if player.souls >= sharpenPrice and player.playerAttack < 75:
		player.souls -= sharpenPrice
		player.playerAttack += 5

func _on_upgrade_pressed() -> void:
	menuButtonSound.play()
	if player.souls >= upgradePrice and player.UPGRADE == 0:
		player.souls -= upgradePrice
		player.UPGRADE = 1

func _on_spell_upgrade_pressed() -> void:
	menuButtonSound.play()
	if player.souls >= armorUpgradePrice and player.maxArmor < 100:
		player.souls -= armorUpgradePrice
		player.maxArmor += 10
