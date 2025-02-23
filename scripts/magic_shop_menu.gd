extends Control

@onready var startMenu: Control = $"../StartMenu"
@onready var shopMenu: Control = $"."
@onready var player: CharacterBody3D = $"../../player"
@onready var menuButtonSound: AudioStreamPlayer = $"../../sounds/menuButton"
@onready var dialogue_menu: Control = $"../DialogueMenu"
@onready var dialogueFocus: Button = $"../DialogueMenu/dialogueButtons/VBoxContainer/text1"

#Item price labels
@onready var price_labels: MarginContainer = $priceLabels

@onready var armorLabel: Label = $priceLabels/VBoxContainer/armor
@onready var spellLabel: Label = $priceLabels/VBoxContainer/spell
@onready var sharpLabel: Label = $priceLabels/VBoxContainer/sharp
@onready var upgradeLabel: Label = $priceLabels/VBoxContainer/upgrade
@onready var soul_label: Label = $souls/soulLabel
@onready var spell_upgrade_label: Label = $priceLabels/VBoxContainer/spellUpgrade

@onready var info_labels: MarginContainer = $infoLabels

#Buttons
@onready var item_buttons: MarginContainer = $itemButtons

#icons
@onready var shield: TextureRect = $shield
@onready var mana: TextureRect = $mana
@onready var spell_scroll: TextureRect = $spellScroll
@onready var upgrade_sword: TextureRect = $upgradeSword
@onready var longsword: TextureRect = $longsword
@onready var player_magic_label: Label = $magicLabel
@onready var player_mana_label: Label = $manaLabel


var fireballPrice: int = 500
var icyclePrice: int = 400
var lightningPrice: int = 600
var spellUpgradePrice: int = 200
var manaUpgradePrice: int = 200
var infoSwap: int = 0

func _process(_delta: float) -> void:
	
	if player.SPELL == 0:
		player_mana_label.text = "   : N/A"
		player_magic_label.text = "   : N/A"
	else:
		player_mana_label.text = "   : " + str(player.playerMagicRegen * 100)
		player_magic_label.text = "   : " + str(player.playerMagicAtk)
	
	if infoSwap == 0:
		price_labels.show()
		item_buttons.show()
		shield.show()
		mana.show()
		spell_scroll.show()
		upgrade_sword.show()
		longsword.show()
		
		info_labels.hide()
	elif infoSwap == 1:
		price_labels.hide()
		item_buttons.hide()
		shield.hide()
		mana.hide()
		spell_scroll.hide()
		upgrade_sword.hide()
		longsword.hide()
		
		info_labels.show()
	
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
		if player.playerMagicRegen < 0.45:
			spell_upgrade_label.text = "-" + str(manaUpgradePrice)
			spell_upgrade_label.set("theme_override_colors/font_color", Color(255, 255, 255))
		else:
			spell_upgrade_label.text = "Purchased"
			spell_upgrade_label.set("theme_override_colors/font_color", Color(0, 255, 0))
	else:
		spell_upgrade_label.text = "N/A"
		spell_upgrade_label.set("theme_override_colors/font_color", Color(255, 0, 0))
	
	soul_label.text = "   : " + str(player.souls)

func _on_yes_pressed() -> void:
	infoSwap = 0
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
	if player.souls >= manaUpgradePrice and player.playerMagicRegen < 0.45 and player.SPELL == 1:
		player.souls -= manaUpgradePrice
		player.playerMagicRegen += 0.05

func _on_info_button_pressed() -> void:
	menuButtonSound.play()
	if infoSwap == 0:
		infoSwap += 1
	elif infoSwap == 1:
		infoSwap -= 1
		
