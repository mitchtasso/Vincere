extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
@onready var player = $"../../player"
@onready var deathSound = $deathSound
@onready var demon_hit: AudioStreamPlayer3D = $demonHit
@onready var enemy_health_bar: ProgressBar = $SubViewport/enemyHealthBar
@onready var stun_timer: Timer = $stunTimer
@onready var hurtbox: CollisionShape3D = $hurtbox/CollisionShape3D
@onready var hitbox: CollisionShape3D = $hitbox/CollisionShape3D
@onready var demon_death: GPUParticles3D = $demonDeath
@onready var world: Node3D = $"../.."

var magic = load("res://scenes/demon_magic.tscn")
var instance
@onready var arm_cast = $MeshInstance3D/RayCast3D

var HEALTH = 50
var maxHealth = 50
var SPEED = 4.0
var knockbackSpeed = 5.50
var navReset = 0
var navTime = 30
var stunLock = false
var stunVel = -1.10
var death = false
var next_nav_point
var lockedOn = false

var magicReset = 1
var magicResetMax = 0
var magicLimit = 200

func _physics_process(delta):
	
	enemy_health_bar.value = HEALTH
	enemy_health_bar.max_value = maxHealth
	
	if HEALTH <= 0:
		demon_hit.stop()
		deathSound.play()
		death = true
		HEALTH = 1
		hitbox.disabled = true
		navReset = 0
		player.souls += 200
		player.add_point()
		stunLock = true
		demon_death.emitting = true
	if HEALTH >= maxHealth:
		enemy_health_bar.hide()
	elif death == true:
		enemy_health_bar.hide()
	else:
		enemy_health_bar.show()
	
	navReset += 1
	if stunLock == false and world.wave > 6:
		if navReset >= navTime:
			velocity = Vector3.ZERO
			nav_agent.set_target_position(player.global_transform.origin)
			next_nav_point = nav_agent.get_next_path_position()
			velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
		
			navReset = 0
		if death == false:
			rotation.y = lerp_angle(rotation.y, atan2(-velocity.x, -velocity.z), delta * 10.0)
	move_and_slide()
	
	if stunLock == true:
		hurtbox.disabled = true
		if death == false:
			nav_agent.set_target_position(player.global_transform.origin)
			next_nav_point = nav_agent.get_next_path_position()
			velocity = (next_nav_point - global_transform.origin).normalized() * knockbackSpeed * stunVel
			velocity.y = 0.01
		else:
			velocity = Vector3.ZERO
	
	if self.position.y >= 4:
		self.get_parent().remove_child(self)
		self.queue_free()
	elif self.position.y <= -1:
		self.get_parent().remove_child(self)
		self.queue_free()
	
	if player.playerDeath == true:
		navReset = 0
		self.get_parent().remove_child(self)
		self.queue_free()
	
	if magicResetMax >= magicLimit:
		magicResetMax = magicLimit
	magicResetMax += magicReset
	if arm_cast.is_colliding() and death == false:
		velocity *= 0.1
		if magicResetMax >= magicLimit:
			magicResetMax = 0
			instance = magic.instantiate()
			instance.position = arm_cast.global_position
			instance.transform.basis = arm_cast.global_transform.basis
			get_parent().add_child(instance)

func _on_hitbox_area_entered(area):
	if area.is_in_group("magic"):
		velocity = Vector3.ZERO
		demon_hit.play()
		HEALTH -= player.playerMagicAtk
		stunLock = true
		stun_timer.start()
	if area.is_in_group("weapon") and player.attackActive == true:
		demon_hit.play()
		velocity = Vector3.ZERO
		HEALTH -= player.playerAttack
		stunLock = true
		stun_timer.start()

func _on_stun_timer_timeout():
	stunLock = false
	hurtbox.disabled = false

func _on_demon_death_finished() -> void:
	self.get_parent().remove_child(self)
	self.queue_free()
