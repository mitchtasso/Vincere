extends Control

@onready var shopMenu: Control = $"."
@onready var player: CharacterBody3D = $"../../player"
@onready var menuButtonSound: AudioStreamPlayer = $"../../sounds/menuButton"
@onready var dialogue_menu: Control = $"../DialogueMenu"
@onready var dialogueFocus: Button = $"../DialogueMenu/dialogueButtons/VBoxContainer/text1"

#Item buttons
@onready var armorButton: Button = $itemButtons/VBoxContainer/armor
@onready var armorStrengthButton: Button = $itemButtons/VBoxContainer/armorStrength
@onready var sharpenButton: Button = $itemButtons/VBoxContainer/sharpen
@onready var upgradeButton: Button = $itemButtons/VBoxContainer/upgrade

#Item price labels
@onready var armorLabel: Label = $priceLabels/VBoxContainer/armor
@onready var armorStrengthLabel: Label = $priceLabels/VBoxContainer/armorStrength
@onready var sharpLabel: Label = $priceLabels/VBoxContainer/sharp
@onready var upgradeLabel: Label = $priceLabels/VBoxContainer/upgrade
@onready var soul_label: Label = $souls/soulLabel
@onready var info_labels: MarginContainer = $infoLabels

#icons
@onready var shield: TextureRect = $shield
@onready var longsword: TextureRect = $longsword
@onready var upgrade_shield: TextureRect = $upgradeShield
@onready var attack: TextureRect = $attack

var armorPrice: int = 1000
var sharpenPrice: int = 3000
var upgradePrice: int = 10000
var armorUpgradePrice: int = 3000
var infoSwap: int = 0

func _process(_delta: float) -> void:
	
	if infoSwap == 0:
		armorLabel.show()
		armorStrengthLabel.show()
		sharpLabel.show()
		upgradeLabel.show()
		
		armorButton.show()
		armorStrengthButton.show()
		sharpenButton.show()
		upgradeButton.show()
		
		shield.show()
		longsword.show()
		upgrade_shield.show()
		attack.show()
		
		info_labels.hide()
		
	elif infoSwap == 1:
		armorLabel.hide()
		armorStrengthLabel.hide()
		sharpLabel.hide()
		upgradeLabel.hide()
		
		armorButton.hide()
		armorStrengthButton.hide()
		sharpenButton.hide()
		upgradeButton.hide()
		
		shield.hide()
		longsword.hide()
		upgrade_shield.hide()
		attack.hide()
		
		info_labels.show()
	
	if player.ARMOR < player.maxArmor:
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
	
	if player.maxArmor < 100:
		armorStrengthLabel.text = "-" + str(armorUpgradePrice)
		armorStrengthLabel.set("theme_override_colors/font_color", Color(255, 255, 255))
	else:
		armorStrengthLabel.text = "Purchased"
		armorStrengthLabel.set("theme_override_colors/font_color", Color(0, 255, 0))
	
	if player.UPGRADE == 0:
		upgradeLabel.text = "-" + str(upgradePrice)
		upgradeLabel.set("theme_override_colors/font_color", Color(255, 255, 255))
	elif player.UPGRADE == 1:
		upgradeLabel.text = "Purchased"
		upgradeLabel.set("theme_override_colors/font_color", Color(0, 255, 0))
	
	soul_label.text = "   : " + str(player.souls)

func _on_yes_pressed() -> void:
	infoSwap = 0
	menuButtonSound.play()
	shopMenu.hide()
	dialogue_menu.show()
	dialogueFocus.grab_focus()	

func _on_armor_pressed() -> void:
	menuButtonSound.play()
	if player.souls >= armorPrice and player.ARMOR < player.maxArmor:
		player.souls -= armorPrice
		player.ARMOR += player.maxArmor

func _on_armor_strength_pressed() -> void:
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

func _on_info_button_pressed() -> void:
	menuButtonSound.play()
	if infoSwap == 0:
		infoSwap += 1
	elif infoSwap == 1:
		infoSwap -= 1
		
