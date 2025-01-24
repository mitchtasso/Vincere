extends MeshInstance3D

@onready var player_detect: ShapeCast3D = $playerDetect
@onready var continue_menu: Control = $"../../../UI/ContinueMenu"
@onready var uiOptionsContinue: Button = $"../../../UI/ContinueMenu/buttons/VBoxContainer/Yes"
@onready var player: CharacterBody3D = $"../../../player"
@onready var start_menu: Control = $"../../../UI/StartMenu"
@onready var detect_text: Label = $"../../../UI/crosshairText/VBoxContainer/Label"

func _process(_delta: float) -> void:
	
	if player_detect.is_colliding():
		detect_text.text = "(E) Return to Graveyard"
		detect_text.show()
		
		if Input.is_action_just_pressed("interact"):
			continue_menu.show()
			uiOptionsContinue.grab_focus()
			start_menu.menuActive = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().paused = true
		
func _on_area_3d_area_exited(_area: Area3D) -> void:
	detect_text.hide()
