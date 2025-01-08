extends Node3D

@onready var blood: GPUParticles3D = $blood

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	blood.emitting = true

func _on_blood_finished() -> void:
	self.queue_free()
