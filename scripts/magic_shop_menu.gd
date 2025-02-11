extends Control

@onready var startMenu: Control = $"../StartMenu"
@onready var shopMenu: Control = $"."
@onready var player: CharacterBody3D = $"../../player"
@onready var menuButtonSound: AudioStreamPlayer = $"../../sounds/menuButton"
@onready var dialogue_menu: Control = $"../DialogueMenu"
@onready var dialogueFocus: Button = $"../DialogueMenu/dialogueButtons/VBoxContainer/text1"

#Item price labels
@onready var armorLabel: Label = $priceLabels/VBoxContainer/armor
@onready var spellLabel: Label = $priceLabels/VBoxContainer/spell
@onready var sharpLabel: Label = $priceLabels/VBoxContainer/sharp
@onready var upgradeLabel: Label = $priceLabels/VBoxContainer/upgrade
@onready var soul_label: Label = $souls/soulLabel
@onready var spell_upgrade_label: Label = $priceLabels/VBoxContainer/spellUpgrade

var fireballPrice: int = 1000
var icyclePrice: int = 1000
var lightningPrice: int = 1000
var spellUpgradePrice: int = 1000
var manaUpgradePrice: int = 1000

func _process(_delta: float) -> void:
	
	if player.fireSpell < 1:
		armorLabel.text = "-" + str(fireballPrice)
		armorLabel.set("theme_override_colors/font_color", Color(255, 255, 255))
	else:
		armorLabel.text = "Purchased"
		armorLabel.set("theme_override_colors/font_color", Color(0, 255, 0))
	
	if player.iceSpell < 1:
		sharpLabel.text = "-" + str(icyclePrice)
		sharpLabel.set("theme_override_colors/font_color", Color(255, 255, 255))
	else:
		sharpLabel.text = "Purchased"
		sharpLabel.set("theme_override_colors/font_color", Color(0, 255, 0))
	
	if player.lightningSpell < 1:
		upgradeLabel.text = "-" + str(lightningPrice)
		upgradeLabel.set("theme_override_colors/font_color", Color(255, 255, 255))
	else:
		upgradeLabel.text = "Purchased"
		upgradeLabel.set("theme_override_colors/font_color", Color(0, 255, 0))
	
	if player.playerMagicAtk < 75:
		if player.SPELL == 1:
			spellLabel.text = "-" + str(spellUpgradePrice)
			spellLabel.set("theme_override_colors/font_color", Color(255, 255, 255))
		else:
			spellLabel.text = "N/A"
			spellLabel.set("theme_override_colors/font_color", Color(255, 0, 0))
	else:
		spellLabel.text = "Purchased"
		spellLabel.set("theme_override_colors/font_color", Color(0, 255, 0))
	
	if player.SPELL == 1:
		spell_upgrade_label.text = "-" + str(manaUpgradePrice)
		spell_upgrade_label.set("theme_override_colors/font_color", Color(255, 255, 255))
	else:
		spell_upgrade_label.text = "N/A"
		spell_upgrade_label.set("theme_override_colors/font_color", Color(255, 0, 0))
	
	soul_label.text = "   : " + str(player.souls)

func _on_yes_pressed() -> void:
	menuButtonSound.play()
	shopMenu.hide()
	dialogue_menu.show()
	dialogueFocus.grab_focus()	

func _on_fireball_pressed() -> void:
	menuButtonSound.play()
	if player.souls >= fireballPrice and player.fireSpell < 1:
		player.souls -= fireballPrice
		player.fireSpell = 1
		player.SPELL = 1

func _on_icycle_pressed() -> void:
	menuButtonSound.play()
	if player.souls >= icyclePrice and player.iceSpell < 1:
		player.souls -= icyclePrice
		player.iceSpell = 1
		player.SPELL = 1

func _on_lightning_pressed() -> void:
	menuButtonSound.play()
	if player.souls >= lightningPrice and player.lightningSpell < 1:
		player.souls -= lightningPrice
		player.lightningSpell = 1
		player.SPELL = 1

func _on_spell_upgrade_pressed() -> void:
	menuButtonSound.play()
	if player.souls >= spellUpgradePrice and player.playerMagicAtk < 75 and player.SPELL == 1:
		player.souls -= spellUpgradePrice
		player.playerMagicAtk += 5

func _on_mana_upgrade_pressed() -> void:
	menuButtonSound.play()
	if player.souls >= spellUpgradePrice and player.playerMagicAtk < 75 and player.SPELL == 1:
		player.souls -= spellUpgradePrice
		player.playerMagicAtk += 5
