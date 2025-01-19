extends CharacterBody3D

@onready var boss_enemy: CharacterBody3D = $"."
@onready var nav_agent = $NavigationAgent3D
@onready var player = $"../../player"
@onready var enemy_health_bar: ProgressBar = $"../../UI/bossHealthbar/ProgressBar"
@onready var boss_healthbar: Control = $"../../UI/bossHealthbar"
@onready var stun_timer: Timer = $stunTimer
@onready var hurtbox: CollisionShape3D = $hurtbox/CollisionShape3D
@onready var hitbox: CollisionShape3D = $hitbox/CollisionShape3D
@onready var demon_death: GPUParticles3D = $demonDeath
@onready var demon_hit: AudioStreamPlayer3D = $demonHit
@onready var death_sound: AudioStreamPlayer3D = $deathSound
@onready var world: Node3D = $"../.."
@onready var boss_animation: AnimationPlayer = $bossAnimation


var HEALTH = 1000
var maxHealth = 1000
var SPEED = 6.0
var stunSpeed = 0.9
var deathSpeed = 0.01
var navReset = 0
var navTime = 30
var stunLock = false
var death = false
var POS = Vector3(-16.3404, 0, 20.2868)

func _physics_process(delta):
	
	enemy_health_bar.value = HEALTH
	enemy_health_bar.max_value = maxHealth
	
	if player.modeType == 2:
		boss_healthbar.show()
	else:
		boss_healthbar.hide()
	
	if death == true:
		boss_healthbar.hide()
	
	if HEALTH <= 0:
		demon_hit.stop()
		death_sound.play()
		death = true
		HEALTH = 1
		hitbox.disabled = true
		navReset = 0
		player.souls += 50000
		player.add_point()
		SPEED = 0.1
		demon_death.emitting = true
	
	navReset += 1
	if navReset >= navTime and player.modeType == 2:
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
	
	if player.playerDeath == true:
		HEALTH = maxHealth
		boss_enemy.position = POS

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
	self.queue_free()

func _on_melee_detection_area_entered(area: Area3D) -> void:
	if area.is_in_group("player"):
		boss_animation.play("attack")

func _on_boss_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		boss_animation.play("idle")
