extends StaticBody3D
@onready var bullseyeLabel: Label = $SubViewport/Label
@onready var reset_timer: Timer = $resetTimer
@onready var hit_sound: AudioStreamPlayer3D = $hitSound

func _on_bullseye_area_entered(area: Area3D) -> void:
	if area.is_in_group("magic"):
		hit_sound.play()
		bullseyeLabel.show()
		reset_timer.start()
	if area.is_in_group("lightningMagic"):
		hit_sound.play()
		bullseyeLabel.show()
		reset_timer.start()
	if area.is_in_group("iceMagic"):
		hit_sound.play()
		bullseyeLabel.show()
		reset_timer.start()

func _on_reset_timer_timeout() -> void:
	bullseyeLabel.hide()
