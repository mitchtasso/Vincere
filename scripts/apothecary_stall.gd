extends MeshInstance3D

@onready var player_detect: ShapeCast3D = $playerDetect
@onready var detect_text: Sprite3D = $detectText
@onready var shop_menu: Control = $"../../../UI/ShopMenu"
@onready var yesButton: Button = $"../../../UI/ShopMenu/buttons/VBoxContainer/Yes"
@onready var player: CharacterBody3D = $"../../../player"
@onready var start_menu: Control = $"../../../UI/StartMenu"
@onready var dialogue_menu: Control = $"../../../UI/DialogueMenu"
@onready var dialogueFocus: Button = $"../../../UI/DialogueMenu/dialogueButtons/VBoxContainer/text1"

func _process(_delta: float) -> void:
	
	if player_detect.is_colliding():
		detect_text.show()
		
		if Input.is_action_just_pressed("interact"):
			dialogue_menu.show()
			dialogue_menu.activeNPC = dialogue_menu.NPC[1]
			dialogue_menu.text_1.text = "Who are you?"
			dialogue_menu.text_2.text = "Heal me please, I am injured."
			dialogue_menu.text_3.text = "Where do you get your power from?"
			dialogue_menu.text_4.text = "Farewell."
			dialogueFocus.grab_focus()
			start_menu.menuActive = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().paused = true
		
	else:
		detect_text.hide()
	
