extends MeshInstance3D

@onready var player_detect: ShapeCast3D = $playerDetect
@onready var start_menu: Control = $"../../../UI/StartMenu"
@onready var dialogue_menu: Control = $"../../../UI/DialogueMenu"
@onready var dialogueFocus: Button = $"../../../UI/DialogueMenu/dialogueButtons/VBoxContainer/text1"
@onready var detect_text: Label = $"../../../UI/crosshairText/VBoxContainer/Label"

func _process(_delta: float) -> void:
	
	if player_detect.is_colliding():
		detect_text.show()
		detect_text.text = "(E) Talk to Medicus"
		
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
		
func _on_area_3d_area_exited(_area: Area3D) -> void:
	detect_text.hide()
