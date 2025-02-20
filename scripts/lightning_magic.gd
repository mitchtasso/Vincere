extends Area3D

var SPEED: float = 40.0

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var ray: ShapeCast3D = $ShapeCast3D
@onready var particle: GPUParticles3D = $explosion
@onready var sizzle: AudioStreamPlayer3D = $sizzle
@onready var boom: AudioStreamPlayer3D = $boom

var reset: int = 0
var time: int = 25
var explosion: int = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	position += transform.basis * Vector3(0,-SPEED, -SPEED * 0.15) * delta
	
	if ray.is_colliding() and explosion == 0:
		sizzle.stop()
		boom.play()
		mesh.visible = false
		SPEED = 0.0001
		particle.emitting = true
		explosion = 1
		reset = 1
	
	time -= reset
	if time <= 0:
		self.get_parent().remove_child(self)
		self.queue_free()
