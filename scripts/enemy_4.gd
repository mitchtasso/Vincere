extends CharacterBody3D

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var player: CharacterBody3D = $"../../player"
@onready var deathSound: AudioStreamPlayer3D = $deathSound
@onready var demon_hit: AudioStreamPlayer3D = $demonHit
@onready var enemy_health_bar: ProgressBar = $SubViewport/enemyHealthBar
@onready var stun_timer: Timer = $stunTimer
@onready var hurtbox: CollisionShape3D = $hurtbox/CollisionShape3D
@onready var hitbox: CollisionShape3D = $hitbox/CollisionShape3D
@onready var demon_death: GPUParticles3D = $demonDeath
@onready var world: Node3D = $"../.."
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var i_frame_timer: Timer = $iFrameTimer
@onready var ice_block: MeshInstance3D = $MeshInstance3D/iceBlock
@onready var frozen_timer: Timer = $frozenTimer

var magic = load("res://scenes/demon_magic.tscn")
var instance
@onready var arm_cast = $MeshInstance3D/RayCast3D

var HEALTH: int = 50
var maxHealth: int = 50
var SPEED: float = 4.0
var knockbackSpeed: float = 5.60
var navReset: int = 0
var navTime: int = 30
var stunLock: bool = false
var stunVel: float = -1.10
var death: bool = false
var next_nav_point
var lockedOn: bool = false
var souls: int = 20
var iFrame: bool = false
var frozen: bool = false

var magicReset: int = 1
var magicResetMax: int = 0
var magicLimit: int = 200

func _physics_process(delta):
	
	enemy_health_bar.value = HEALTH
	enemy_health_bar.max_value = maxHealth
	
	if HEALTH <= 0:
		hitbox.disabled = true
		demon_hit.stop()
		deathSound.play()
		death = true
		HEALTH = 1
		navReset = 0
		player.souls += souls
		player.add_point()
		stunLock = true
		demon_death.emitting = true
		animation_player.play("death")
	
	if death == true:
		hitbox.disabled = true
		hurtbox.disabled = true
	
	if frozen == true:
		hurtbox.disabled = true
	
	if HEALTH >= maxHealth:
		enemy_health_bar.hide()
	elif death == true:
		enemy_health_bar.hide()
	else:
		enemy_health_bar.show()
	
	navReset += 1
	if frozen == false:
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
		nav_agent.set_target_position(player.global_transform.origin)
		next_nav_point = nav_agent.get_next_path_position()
		velocity = (next_nav_point - global_transform.origin).normalized() * knockbackSpeed * stunVel
		velocity.y = 0.01
	
	if self.position.y >= 4:
		self.get_parent().remove_child(self)
		self.queue_free()
	elif self.position.y <= -1:
		self.get_parent().remove_child(self)
		self.queue_free()
	
	if player.playerDeath == true and death == false:
		souls = 0
		knockbackSpeed = 0.1
		navReset = 0
		HEALTH = 0
	
	if magicResetMax >= magicLimit:
		magicResetMax = magicLimit
	magicResetMax += magicReset
	if arm_cast.is_colliding() and death == false and frozen == false:
		velocity *= 0.1
		if magicResetMax >= magicLimit:
			magicResetMax = 0
			instance = magic.instantiate()
			instance.position = arm_cast.global_position
			instance.transform.basis = arm_cast.global_transform.basis
			get_parent().add_child(instance)

func _on_hitbox_area_entered(area):
	if area.is_in_group("lightningMagic") and iFrame == false:
		velocity = Vector3.ZERO
		demon_hit.play()
		HEALTH -= player.playerMagicAtk * 0.5
		stunLock = true
		stun_timer.start()
		iFrame = true
		i_frame_timer.start()
	if area.is_in_group("iceMagic") and iFrame == false:
		velocity = Vector3.ZERO
		demon_hit.play()
		HEALTH -= player.playerMagicAtk * 0.75
		frozen = true
		frozen_timer.start()
		ice_block.show()
		iFrame = true
		i_frame_timer.start()
	if area.is_in_group("magic") and iFrame == false:
		velocity = Vector3.ZERO
		demon_hit.play()
		HEALTH -= player.playerMagicAtk
		stunLock = true
		stun_timer.start()
		iFrame = true
		i_frame_timer.start()
	if area.is_in_group("weapon") and player.attackActive == true and iFrame == false:
		demon_hit.play()
		velocity = Vector3.ZERO
		HEALTH -= player.playerAttack
		stunLock = true
		stun_timer.start()
		iFrame = true
		i_frame_timer.start()

func _on_stun_timer_timeout():
	stunLock = false
	hurtbox.disabled = false

func _on_demon_death_finished() -> void:
	self.get_parent().remove_child(self)
	self.queue_free()

func _on_i_frame_timer_timeout() -> void:
	iFrame = false

func _on_frozen_timer_timeout() -> void:
	hurtbox.disabled = false
	frozen = false
	ice_block.hide()
