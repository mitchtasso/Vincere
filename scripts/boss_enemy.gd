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

# Magic 
var magic = load("res://scenes/boss_magic.tscn")
var instance
@onready var arm_cast: RayCast3D = $Head/ArmMesh/RayCast3D
@onready var arm_mesh: MeshInstance3D = $Head/ArmMesh

var HEALTH: float = 2000
var maxHealth: float = 2000
var SPEED: float = 10.0
var maxSpeed: float = 10.0
var stunSpeed: float = 0.9
var deathSpeed: float = 0.01
var navReset: int = 0
var navTime: int = 30
var stunLock: bool = false
var death: bool = false
var POS: Vector3 = Vector3(-107.785, 0, 21)
var attackActive: bool = false
var attackAvailable: bool = true
var magicAvailable: bool = true
var randomAttack

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
		player.add_point()
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
	if navReset >= navTime and player.modeType == 2 and death == false:
		velocity = Vector3.ZERO
		nav_agent.set_target_position(player.global_transform.origin)
		var next_nav_point = nav_agent.get_next_path_position()
		velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	
		navReset = 0
	if death == false:
		rotation.y = lerp_angle(rotation.y, atan2(-velocity.x, -velocity.z), delta * 10.0)
	move_and_slide()
	
	if stunLock == true:
		SPEED = maxSpeed/4
	
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
	SPEED = maxSpeed
	hurtbox.disabled = false

func _on_demon_death_finished() -> void:
	cleric.position = Vector3(0,0.068,0)
	world.gameEnd = true
	self.queue_free()

func _on_melee_detection_area_entered(area: Area3D) -> void:
	if area.is_in_group("player") and attackAvailable == true and randomAttack == 0 and attackActive == false:
		boss_animation.play("attack")
	if area.is_in_group("player") and attackAvailable == true and randomAttack == 1 and attackActive == false:
		boss_animation.play("attack2")
	if area.is_in_group("player") and attackAvailable == true and randomAttack == 2 and attackActive == false:
		boss_animation.play("attack3")

func _on_ranged_detection_area_entered(area: Area3D) -> void:
	if area.is_in_group("player") and magicAvailable == true and attackActive == false:
		boss_animation.play("cast")

func _on_boss_animation_animation_started(anim_name: StringName) -> void:
	if anim_name == "attack":
		magicAvailable = false
		attackActive = true
		SPEED *= 0.01
	if anim_name == "attack2":
		magicAvailable = false
		attackActive = true
		SPEED *= 0.01
	if anim_name == "attack3":
		magicAvailable = false
		attackActive = true
		SPEED *= 0.01
	if anim_name == "cast":
		attackAvailable = false
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
