extends StaticBody3D
@onready var bullseyeLabel: Label = $SubViewport/Label
@onready var reset_timer: Timer = $resetTimer


func _on_bullseye_area_entered(area: Area3D) -> void:
	if area.is_in_group("magic"):
		bullseyeLabel.show()
		reset_timer.start()

func _on_reset_timer_timeout() -> void:
	bullseyeLabel.hide()
