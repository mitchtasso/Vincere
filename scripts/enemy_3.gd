extends CharacterBody3D

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var player: CharacterBody3D = $"../../player"
@onready var enemy_health_bar: ProgressBar = $SubViewport/enemyHealthBar
@onready var stun_timer: Timer = $stunTimer
@onready var hurtbox: CollisionShape3D = $hurtbox/CollisionShape3D
@onready var hitbox: CollisionShape3D = $hitbox/CollisionShape3D
@onready var demon_death: GPUParticles3D = $demonDeath
@onready var demon_hit: AudioStreamPlayer3D = $demonHit
@onready var death_sound: AudioStreamPlayer3D = $deathSound
@onready var world: Node3D = $"../.."
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var HEALTH: int = 150
var maxHealth: int = 150
var SPEED: float = 5.5
var stunSpeed: float = 0.9
var deathSpeed: float = 0.01
var navReset: int = 0
var navTime: int = 60
var stunLock: bool = false
var death: bool = false
var souls: int = 300

func _physics_process(delta):
	
	enemy_health_bar.value = HEALTH
	enemy_health_bar.max_value = maxHealth
	
	if HEALTH <= 0:
		demon_hit.stop()
		death_sound.play()
		death = true
		HEALTH = 1
		hitbox.disabled = true
		navReset = 0
		player.souls += souls
		player.add_point()
		SPEED = 0.1
		demon_death.emitting = true
		animation_player.play("death")
	if HEALTH >= maxHealth:
		enemy_health_bar.hide()
	elif death == true:
		enemy_health_bar.hide()
	else:
		enemy_health_bar.show()
	
	navReset += 1
	if navReset >= navTime and world.wave > 4:
		velocity = Vector3.ZERO
		nav_agent.set_target_position(player.global_transform.origin)
		var next_nav_point = nav_agent.get_next_path_position()
		velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	
		navReset = 0
	if death == false:
		rotation.y = lerp_angle(rotation.y, atan2(-velocity.x, -velocity.z), delta * 10.0)
	move_and_slide()
	
	if stunLock == true:
		SPEED = 2.5
		hurtbox.disabled = true
	
	if self.position.y >= 4:
		self.get_parent().remove_child(self)
		self.queue_free()
	elif self.position.y <= -1:
		self.get_parent().remove_child(self)
		self.queue_free()
	
	if player.playerDeath == true and death == false:
		souls = 0
		SPEED = 0.1
		navReset = 0
		HEALTH = 0

func _on_hitbox_area_entered(area):
	if area.is_in_group("magic"):
		demon_hit.play()
		HEALTH -= player.playerMagicAtk
		stunLock = true
		stun_timer.start()
	if area.is_in_group("weapon") and player.attackActive == true:
		demon_hit.play()
		HEALTH -= player.playerAttack
		stunLock = true
		stun_timer.start()

func _on_stun_timer_timeout():
	stunLock = false
	SPEED = 5.0
	hurtbox.disabled = false

func _on_demon_death_finished() -> void:
	self.get_parent().remove_child(self)
	self.queue_free()
