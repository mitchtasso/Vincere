extends StaticBody3D

@onready var player_detect: ShapeCast3D = $playerDetect
@onready var uiOptions: Button = $"../../UI/DialogueMenu/dialogueButtons/VBoxContainer/text1"
@onready var start_menu: Control = $"../../UI/StartMenu"
@onready var dialogue_menu: Control = $"../../UI/DialogueMenu"
@onready var detect_text: Label = $"../../UI/crosshairText/VBoxContainer/Label"
@onready var world: Node3D = $"../.."
@onready var exclaim: Sprite3D = $Sprite3D
@onready var cleric_appear: GPUParticles3D = $clericAppear
@onready var boss_defeated_label: Label = $"../../UI/bossDefeated"

func _process(_delta: float) -> void:
	
	if world.gameEnd == true:
		exclaim.show()
	else:
		exclaim.hide()
	
	if player_detect.is_colliding():
		detect_text.show()
		detect_text.text = "(E) Talk to Unknown Cleric"
		
		if Input.is_action_just_pressed("interact"):
			if world.gameEnd == false:
				dialogue_menu.activeNPC = dialogue_menu.NPC[2]
				dialogue_menu.dialoguePic.texture = dialogue_menu.clericPic
				dialogue_menu.title.text = "Unknown Cleric"
				dialogue_menu.dialogLabel.text = "Fateful knight, pleased to make your acquaintance."
				dialogue_menu.text_1.text = "Who are you?"
				dialogue_menu.text_2.text = "Fateful? What makes me fateful?"
				dialogue_menu.text_3.text = "What information do you possess?"
				dialogue_menu.text_4.text = "Farewell."
				dialogue_menu.show()
				uiOptions.grab_focus()
				start_menu.menuActive = true
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				get_tree().paused = true
			else:
				dialogue_menu.activeNPC = dialogue_menu.NPC[3]
				dialogue_menu.dialoguePic.texture = dialogue_menu.clericPic
				dialogue_menu.title.text = "Cappellanus"
				dialogue_menu.dialogLabel.text = "Fateful knight, you have vanquished the demons of this land."
				dialogue_menu.text_1.text = "What happens now?"
				dialogue_menu.text_2.text = "Who are you really?"
				dialogue_menu.text_3.text = "Are there any more?"
				dialogue_menu.text_4.text = "Let us depart. (GAME END)"
				dialogue_menu.show()
				uiOptions.grab_focus()
				start_menu.menuActive = true
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				get_tree().paused = true
	
func _on_player_field_area_exited(_area: Area3D) -> void:
	detect_text.hide()


func _on_cleric_timer_timeout() -> void:
	self.position = Vector3(0,0.068,0)
	cleric_appear.emitting = true

func _on_timer_timeout() -> void:
	boss_defeated_label.hide()
