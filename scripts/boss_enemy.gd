extends CharacterBody3D

@onready var boss_enemy: CharacterBody3D = $"."
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var player: CharacterBody3D = $"../player"
@onready var enemy_health_bar: ProgressBar = $"../UI/bossHealthbar/ProgressBar"
@onready var boss_healthbar: Control = $"../UI/bossHealthbar"
@onready var stun_timer: Timer = $stunTimer
@onready var hurtbox: CollisionShape3D = $Head/WeaponPivot/WeaponMesh/Hitbox/CollisionShape3D
@onready var hitbox: CollisionShape3D = $hitbox/CollisionShape3D
@onready var demon_death: GPUParticles3D = $demonDeath
@onready var demon_hit: AudioStreamPlayer3D = $demonHit
@onready var death_sound: AudioStreamPlayer3D = $deathSound
@onready var world: Node3D = $".."
@onready var boss_animation: AnimationPlayer = $bossAnimation
@onready var attack_reset: Timer = $attackReset
@onready var magic_reset: Timer = $magicReset
@onready var eyes: Node3D = $eyes
@onready var cleric: StaticBody3D = $"../BossRoom/cleric"
@onready var slash_sound: AudioStreamPlayer3D = $Head/WeaponPivot/WeaponMesh/slashSound
@onready var cast_sound: AudioStreamPlayer3D = $Head/ArmMesh/castSound
@onready var i_frame_timer: Timer = $iFrameTimer
@onready var frozen_timer: Timer = $frozenTimer
@onready var ice_block: MeshInstance3D = $MeshInstance3D/iceBlock
@onready var explosion: GPUParticles3D = $explosion
@onready var boom: AudioStreamPlayer3D = $boom
@onready var dodge_timer: Timer = $dodgeTimer
@onready var cleric_timer: Timer = $"../BossRoom/clericTimer"
@onready var boss_defeated_label: Label = $"../UI/bossDefeated"
@onready var boss_defeated_timer: Timer = $"../UI/bossDefeated/Timer"

# Magic 
var magic = load("res://scenes/boss_magic.tscn")
var instance
@onready var arm_cast: RayCast3D = $Head/ArmMesh/RayCast3D
@onready var arm_mesh: MeshInstance3D = $Head/ArmMesh

var HEALTH: float = 100
var maxHealth: float = 100
var SPEED: float = 10.0
var maxSpeed: float = 10.0
var stunSpeed: float = 0.9
var deathSpeed: float = 0.01
var navReset: int = 0
var navTime: int = 1
var stunLock: bool = false
var death: bool = false
var POS: Vector3 = Vector3(-107.785, 0, 21)
var attackActive: bool = false
var attackAvailable: bool = true
var magicAvailable: bool = true
var randomAttack: int
var iFrame: bool = false
var frozen: bool = false
var playerDetect: bool = false
var dodge: bool = false
var dodgeReset: bool = false
var dodgeSpeed: float = -20.0
var next_nav_point

func _physics_process(delta):
	
	enemy_health_bar.value = HEALTH
	enemy_health_bar.max_value = maxHealth
	randomAttack = randi_range(0,2)
	
	if player.modeType == 2:
		boss_healthbar.show()
	else:
		boss_healthbar.hide()
	
	if death == true:
		boss_healthbar.hide()
	
	if HEALTH <= 0:
		demon_death.emitting = true
		boss_animation.play("death")
		magicAvailable = false
		attackAvailable = false
		demon_hit.stop()
		death_sound.play()
		death = true
		HEALTH = 1
		hitbox.disabled = true
		navReset = 0
		player.souls += 50000
		player.bossKills += 1
		player.add_point()
		player.save_boss_kills()
		velocity = Vector3.ZERO
	
	if HEALTH <= maxHealth/2:
		eyes.show()
		magic_reset.wait_time = 1.0
		attack_reset.wait_time = 0.5
		maxSpeed = 15.0
	else:
		eyes.hide()
		magic_reset.wait_time = 2.0
		attack_reset.wait_time = 1.0
		maxSpeed = 10.0
	
	navReset += 1
	if navReset >= navTime and player.modeType == 2 and death == false and dodge == false:
		velocity = Vector3.ZERO
		nav_agent.set_target_position(player.global_transform.origin)
		next_nav_point = nav_agent.get_next_path_position()
		velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	
		navReset = 0
	if death == false :
		rotation.y = lerp_angle(rotation.y, atan2(-velocity.x, -velocity.z), delta * 10.0)
	move_and_slide()
	
	if stunLock == true and dodge == false:
		SPEED = maxSpeed * 0.75
	
	if frozen == true and dodge == false:
		SPEED = maxSpeed * 0.75
	
	if attackActive == true and dodge == false:
		SPEED = maxSpeed * 0.01
	
	if playerDetect == true and dodge == false:
		SPEED = maxSpeed * 0.4
	
	if dodge == true:
		velocity = Vector3.ZERO
		nav_agent.set_target_position(player.global_transform.origin)
		next_nav_point = nav_agent.get_next_path_position()
		velocity = (next_nav_point - global_transform.origin).normalized() * dodgeSpeed
		velocity.y = 0.01
	
	if player.playerDeath == true:
		HEALTH = maxHealth
		boss_enemy.position = POS

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
		demon_hit.play()
		HEALTH -= player.playerMagicAtk
		stunLock = true
		stun_timer.start()
		iFrame = true
		i_frame_timer.start()
	if area.is_in_group("weapon") and player.attackActive == true and iFrame == false:
		demon_hit.play()
		HEALTH -= player.playerAttack
		stunLock = true
		stun_timer.start()
		iFrame = true
		i_frame_timer.start()

func _on_stun_timer_timeout():
	stunLock = false
	SPEED = maxSpeed
	hurtbox.disabled = false

func _on_demon_death_finished() -> void:
	explosion.emitting = true
	boom.play()

func _on_explosion_finished() -> void:
	cleric_timer.start()
	boss_defeated_label.show()
	boss_defeated_timer.start()
	world.gameEnd = true
	self.queue_free()

func _on_melee_detection_area_entered(area: Area3D) -> void:
	if area.is_in_group("player"):
		playerDetect = true
	if area.is_in_group("player") and attackAvailable == true and randomAttack == 0 and attackActive == false:
		boss_animation.play("attack")
		slash_sound.play()
	if area.is_in_group("player") and attackAvailable == true and randomAttack == 1 and attackActive == false:
		boss_animation.play("attack2")
		slash_sound.play()
	if area.is_in_group("player") and attackAvailable == true and randomAttack == 2 and attackActive == false:
		boss_animation.play("attack3")
		slash_sound.play()

func _on_melee_detection_area_exited(area: Area3D) -> void:
	if area.is_in_group("player"):
		playerDetect = false

func _on_ranged_detection_area_entered(area: Area3D) -> void:
	if area.is_in_group("player") and magicAvailable == true and attackActive == false:
		boss_animation.play("cast")
		cast_sound.play()

func _on_boss_animation_animation_started(anim_name: StringName) -> void:
	if anim_name == "attack":
		magicAvailable = false
		attackActive = true
		if dodge == false:
			SPEED *= 0.01
	if anim_name == "attack2":
		magicAvailable = false
		attackActive = true
		if dodge == false:
			SPEED *= 0.01
	if anim_name == "attack3":
		magicAvailable = false
		attackActive = true
		if dodge == false:
			SPEED *= 0.01
	if anim_name == "cast":
		attackAvailable = false
		if dodge == false:
			SPEED *= 0.01

func _on_boss_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		magicAvailable = true
		attackActive = false
		boss_animation.play("idle")
		SPEED = maxSpeed
		attackAvailable = false
		attack_reset.start()
	if anim_name == "attack2":
		magicAvailable = true
		attackActive = false
		boss_animation.play("idle")
		SPEED = maxSpeed
		attackAvailable = false
		attack_reset.start()
	if anim_name == "attack3":
		magicAvailable = true
		attackActive = false
		boss_animation.play("idle")
		SPEED = maxSpeed
		attackAvailable = false
		attack_reset.start()
	if anim_name == "cast":
		instance = magic.instantiate()
		instance.position = arm_cast.global_position
		instance.transform.basis = arm_cast.global_transform.basis
		get_parent().add_child(instance)
		boss_animation.play("idle")
		SPEED = maxSpeed
		attackAvailable = true
		magicAvailable = false
		magic_reset.start()

func _on_attack_reset_timeout() -> void:
	attackAvailable = true

func _on_magic_reset_timeout() -> void:
	magicAvailable = true

func _on_i_frame_timer_timeout() -> void:
	iFrame = false

func _on_frozen_timer_timeout() -> void:
	frozen = false
	ice_block.hide()

func _on_close_detection_area_entered(area: Area3D) -> void:
	if area.is_in_group("player"):
		dodge = true
		dodge_timer.start()

func _on_dodge_timer_timeout() -> void:
	dodge = false
