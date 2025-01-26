extends Area3D

var SPEED: float = 40.0

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var ray: ShapeCast3D = $ShapeCast3D
@onready var particle: GPUParticles3D = $MeshInstance3D/explosion
@onready var trail: GPUParticles3D = $MeshInstance3D/trail
@onready var sizzle: AudioStreamPlayer3D = $sizzle
@onready var boom: AudioStreamPlayer3D = $boom

var reset: int = 0
var time: int = 600
var explosion: int = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	position += transform.basis * Vector3(SPEED,0,0) * delta
	
	if ray.is_colliding() and explosion == 0:
		
		sizzle.stop()
		boom.play()
		mesh.visible = false
		SPEED = 0.0001
		trail.emitting = false
		particle.emitting = true
		explosion = 1
		reset = 1
	
	time -= reset
	if time <= 0:
		self.queue_free()
