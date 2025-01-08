extends Area3D

var SPEED = 40.0

@onready var mesh = $MeshInstance3D
@onready var ray = $ShapeCast3D
@onready var particle: GPUParticles3D = $explosion
@onready var trail: GPUParticles3D = $trail
@onready var sizzle: AudioStreamPlayer3D = $sizzle
@onready var boom: AudioStreamPlayer3D = $boom

var reset = 0
var time = 600
var explosion = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	position += transform.basis * Vector3(0,0,-SPEED) * delta
	
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
