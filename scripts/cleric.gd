extends StaticBody3D

@onready var player_detect: ShapeCast3D = $playerDetect
@onready var uiOptionsContinue: Button = $"../../UI/ContinueMenu/buttons/VBoxContainer/Yes"
@onready var player: CharacterBody3D = $"../../player"
@onready var start_menu: Control = $"../../UI/StartMenu"
@onready var dialogue_menu: Control = $"../../UI/DialogueMenu"
@onready var detect_text: Label = $"../../UI/crosshairText/VBoxContainer/Label"

func _process(_delta: float) -> void:
	
	if player_detect.is_colliding():
		detect_text.show()
		detect_text.text = "(E) Talk to Unknown Cleric"
		
		if Input.is_action_just_pressed("interact"):
			dialogue_menu.title.text = "Unknown Cleric"
			dialogue_menu.dialogLabel.text = "Fateful knight, pleased to make your acquaintance."
			dialogue_menu.text_1.text = "Who are you?"
			dialogue_menu.text_2.text = "Fateful? What makes me fateful?"
			dialogue_menu.text_3.text = "Do you have any information on the tainted graveyard?"
			dialogue_menu.text_4.text = "Farewell."
			dialogue_menu.show()
			uiOptionsContinue.grab_focus()
			start_menu.menuActive = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().paused = true
		
func _on_player_field_area_exited(_area: Area3D) -> void:
	detect_text.hide()
