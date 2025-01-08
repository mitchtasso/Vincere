extends MeshInstance3D

@onready var player_detect: ShapeCast3D = $playerDetect
@onready var detect_text: Sprite3D = $detectText
@onready var continue_menu: Control = $"../../../UI/ContinueMenu"
@onready var uiOptionsContinue: Button = $"../../../UI/ContinueMenu/buttons/VBoxContainer/Yes"
@onready var player: CharacterBody3D = $"../../../player"
@onready var start_menu: Control = $"../../../UI/StartMenu"

func _process(_delta: float) -> void:
	
	if player_detect.is_colliding():
		detect_text.show()
		
		if Input.is_action_just_pressed("interact"):
			continue_menu.show()
			uiOptionsContinue.grab_focus()
			start_menu.menuActive = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().paused = true
		
	else:
		detect_text.hide()
	
