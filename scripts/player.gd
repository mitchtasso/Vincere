extends CharacterBody3D

var speed
var walking: bool = false
const SPRINT_SPEED: float = 8.5
const JUMP_VELOCITY: float = 5.5
var points: int = 0
var bossKills: int = 0
var souls: int = 0
var attackActive: bool = false
var playerDeath: bool = false
var HEALTH: int = 100
var maxHealth: int = 100
var ARMOR: int = 0
var maxArmor: int = 50
var MANA: float = 0

var SPELL: int = 0 
var fireSpell: int = 0
var lightningSpell: int = 0
var iceSpell: int = 0
var changeSpell: int = 0
var activeSpell: int = 0

var UPGRADE: int = 0
var playerAttack: int = 25
var playerMagicAtk: int = 50
var playerMagicRegen: float = 0.25
var iFrame: bool = false
var dashCool: bool = true
var dashActive: bool = false
var attackType: int = 0
var baseAttack: bool = false
var magicAttack: bool = false

#Bob varibales
const BOB_FREQ: float = 2.0
const BOB_AMP: float = 0.08
var t_bob: float = 2.0

#fov variables
const BASE_FOV: float = 75.0
const FOV_CHANGE: float = 1.5
var graveyardPOS: Vector3 = Vector3(0,-0.5,0)
var shopPOS: Vector3 = Vector3(99,-0.5,0)
var bossRoomPOS: Vector3 = Vector3(-99,-0.5,0)
var SENSITIVITY: float
var controllerSensH: float
var controllerSensV: float
var controllerAxis: Vector2
var mouseSensRate: float = 0.00002
var controllerSensRateH: float = 3.5
var controllerSensRateV: float = 3.5

#Player Elements
@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var animationPlayer: AnimationPlayer = $playerAnimation
@onready var weapon_hitbox: Area3D = $Head/Camera3D/WeaponPivot/WeaponMesh/Hitbox
@onready var player: CharacterBody3D = $"."
@onready var swordSound: AudioStreamPlayer = $"../sounds/swordSwipe"
@onready var walkingSound: AudioStreamPlayer3D = $walkingSound
@onready var jumpSound: AudioStreamPlayer3D = $jumpSound
@onready var dash_sound: AudioStreamPlayer3D = $dashSound
@onready var playerDeathSound: AudioStreamPlayer = $"../sounds/playerDeath"
@onready var dash_cooldown: Timer = $dashCooldown
@onready var dash_active_timer: Timer = $dashActiveTimer
@onready var vin_timer: Timer = $vinTimer
@onready var attack_change_timer: Timer = $attackChange
@onready var i_frame_timer: Timer = $iFrameTimer

@onready var weapon_mesh: MeshInstance3D = $Head/Camera3D/WeaponPivot/WeaponMesh
@onready var shortswordCol: CollisionShape3D = $Head/Camera3D/WeaponPivot/WeaponMesh/Hitbox/CollisionShape3D
@onready var longswordCol: CollisionShape3D = $Head/Camera3D/WeaponPivot/WeaponMesh/Hitbox/CollisionShape3D2
@onready var cast_sound: AudioStreamPlayer3D = $Head/Camera3D/ArmMesh/castSound

var shortsword = preload("res://assets/player/templarArmWsword2.obj")
var longsword = preload("res://assets/player/templarArmWlongsword.obj")
var playerData = PlayerData.new()

# Magic 
var magic
var instance
@onready var arm_cast: RayCast3D = $Head/Camera3D/ArmMesh/RayCast3D
@onready var arm_mesh: MeshInstance3D = $Head/Camera3D/ArmMesh

#Player data save path
var save_file_path: String = "user://VincereData/"
var save_file_name: String = "PlayerData.tres"
var direct_file_path: String = "user://VincereData/"

#Player UI Elements
@onready var gametimer: Timer = $"../gameTime"
@onready var timerLabel: Label = $"../UI/waveUI/VBoxContainer/time"
@onready var waveLabel: Label = $"../UI/waveUI/VBoxContainer/waveLabel"
@onready var pointsLabel: Label = $"../UI/playerUI/VBoxContainer/points"
@onready var fpsLabel: Label = $"../UI/playerUI/VBoxContainer/fps"
@onready var soulsLabel: Label = $"../UI/playerUI/VBoxContainer/souls"
@onready var health_bar: ProgressBar = $"../UI/statsUI/healthBar"
@onready var armor_bar: ProgressBar = $"../UI/statsUI/armorBar"
@onready var mana_bar: ProgressBar = $"../UI/statsUI/manaBar"
@onready var healthVin: TextureRect = $"../UI/healthVin"
@onready var low_health_vin: TextureRect = $"../UI/lowHealthVin"
@onready var spell_UI_pic: TextureRect = $"../UI/statsUI/spell"
@onready var speed_lines: Control = $"../UI/speedLines"
@onready var speed_timer: Timer = $"../UI/speedLines/speedTimer"

#Menu UI Elements
@onready var pauseMenu: Control = $"../UI/PauseMenu"
@onready var deathMenu: Control = $"../UI/DeathMenu"
@onready var waveMenu: Control = $"../UI/WaveMenu"
@onready var startMenu: Control = $"../UI/StartMenu"
@onready var continueMenu: Control = $"../UI/ContinueMenu"
@onready var boss_menu: Control = $"../UI/BossMenu"
@onready var controls_menu: Control = $"../UI/ControlsMenu"
@onready var autosaveLabel: MarginContainer = $"../UI/autoSaveText"
@onready var autosaveTextTimer: Timer = $"../UI/autoSaveText/Timer"
@onready var magic_change_sound: AudioStreamPlayer = $"../sounds/magicChange"

#Wave Menu
@onready var pointsWave: Label = $"../UI/WaveMenu/buttons/VBoxContainer/points"
@onready var soulsWave: Label = $"../UI/WaveMenu/buttons/VBoxContainer/souls"

#Menu focus
@onready var uiOptionsPause: Button = $"../UI/PauseMenu/buttons/VBoxContainer/Resume"
@onready var uiOptionsDeath: Button = $"../UI/DeathMenu/buttons/VBoxContainer/Replay"
@onready var uiOptionsWave: Button = $"../UI/WaveMenu/buttons/VBoxContainer/Continue"
@onready var uiOptionsContinue: Button = $"../UI/ContinueMenu/buttons/VBoxContainer/Yes"
@onready var uiOptionsBoss: Button = $"../UI/BossMenu/buttons/VBoxContainer/Continue"

#World elements
@onready var world: Node3D = $".."
@onready var graveyard: NavigationRegion3D = $"../NavigationRegion3D"
@onready var graveyard_other_textures: Node3D = $"../OtherTextures"
@onready var shop: Node3D = $"../Shop"
@onready var all_enemies: Node3D = $"../allEnemies"
@onready var world_environment: WorldEnvironment = $"../WorldEnvironment"
@onready var sun: DirectionalLight3D = $"../sun"
@onready var boss_room: NavigationRegion3D = $"../BossRoom"
@onready var boss_enemy_character: CharacterBody3D = $"../bossEnemy"

#World variables
var gameTimeSec: int = 59
var gameTimeMin: int = 1
var gameTimeSecDef: int = 59
var gameTimeMinDef: int = 1
var gameTimeChange: int = 1
var modeType: int = 0

#Mouse Input for moving camera
func _input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))

func _physics_process(_delta):
	
	#Pause Game
	if Input.is_action_just_pressed("quit"):
		uiOptionsPause.grab_focus()
		pauseMenu.show()
		startMenu.menuActive = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
		gametimer.stop()
	
	#Attack animation and detecting start
	if Input.is_action_just_pressed("attack") and magicAttack == false:
		animationPlayer.speed_scale = 1.0
		if attackType == 0:
			animationPlayer.play("attack")
		elif attackType == 1:
			animationPlayer.play("attack2")
		elif attackType == 2:
			animationPlayer.play("attack3")
		weapon_hitbox.monitoring = true
	
	if UPGRADE == 0:
		weapon_mesh.mesh = shortsword
		shortswordCol.disabled = false
		longswordCol.disabled = true
	elif UPGRADE == 1:
		weapon_mesh.mesh = longsword
		shortswordCol.disabled = true
		longswordCol.disabled = false
	
	if Input.is_action_just_pressed("castMagic") and baseAttack == false and SPELL == 1:
		if MANA >= 50:
			animationPlayer.play("cast")
			magicAttack = true
			MANA -= 50
	
	if SPELL == 0:
		arm_mesh.hide()
	else:
		arm_mesh.show()
	
	#Change spell system
	if Input.is_action_just_pressed("change_spell"):
		changeSpell += 1
		if SPELL == 1:
			magic_change_sound.play()
	
	if changeSpell >= 3:
		changeSpell = 0
	
	if changeSpell == 0:
		if fireSpell == 1:
			magic = load("res://scenes/beam_magic.tscn")
			spell_UI_pic.texture = load("res://assets/menu/fireball.png")
			activeSpell = 1
		else:
			changeSpell = 1
	elif changeSpell == 1:
		if iceSpell == 1:
			magic = load("res://scenes/ice_magic.tscn")
			spell_UI_pic.texture = load("res://assets/menu/icycle.png")
			activeSpell = 2
		else:
			changeSpell = 2
	elif changeSpell == 2:
		if lightningSpell == 1:
			magic = load("res://scenes/lightning_magic.tscn")
			spell_UI_pic.texture = load("res://assets/menu/lightning.png")
			activeSpell = 3
		else:
			changeSpell = 0
	
	#UI refresh
	var time_string = "%02d:%02d" % [gameTimeMin, gameTimeSec]
	pointsLabel.text = "   : " + str(points)
	soulsLabel.text = "   : " + str(souls)
	timerLabel.text = "   : " + time_string
	health_bar.value = HEALTH
	armor_bar.value = ARMOR
	mana_bar.value = MANA
	
	#Stat refresh
	if ARMOR <= 0:
		ARMOR = 0
	elif ARMOR >= maxArmor:
		ARMOR = maxArmor
	armor_bar.max_value = maxArmor
	if armor_bar.value <= 0:
		armor_bar.hide()
	else:
		armor_bar.show()
	
	if MANA <= 0:
		MANA = 0
	elif MANA >= 50:
		MANA = 50
	mana_bar.max_value = 50
	if mana_bar.value <= 0:
		mana_bar.hide()
	else:
		mana_bar.show()
	
	if SPELL == 1:
		MANA += playerMagicRegen
	
	if HEALTH >= maxHealth:
		HEALTH = maxHealth
	
	if HEALTH < 30:
		low_health_vin.show()
	else:
		low_health_vin.hide()
	

func _process(delta):
	
	SENSITIVITY = controls_menu.mouseSens * mouseSensRate
	controllerSensH = controls_menu.horizSens * controllerSensRateH
	controllerSensV = controls_menu.verticalSens * controllerSensRateV
	
	#Controller camera input
	controllerAxis = Vector2.ZERO
	controllerAxis.x = Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left")
	controllerAxis.y = Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up")
	
	if InputEventJoypadMotion:
		head.rotate_y((deg_to_rad(-controllerAxis.x) * controllerSensH) * delta)
		camera.rotate_x((deg_to_rad(-controllerAxis.y) * controllerSensV) * delta)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	#Handle death
	death()
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and dashActive == false:
		velocity.y = JUMP_VELOCITY
		jumpSound.play()

	# Handle Sprint
	speed = SPRINT_SPEED
	if dashActive == false:
		walkingSound.pitch_scale = 1.3
	
	if Input.is_action_pressed("dash") and dashCool == true and is_on_floor():
		dashCool = false
		dashActive = true
		speed_lines.show()
		speed_timer.start()
		velocity *= 2.5
		walkingSound.pitch_scale = 0.01
		if velocity != Vector3.ZERO:
			dash_sound.play()
		dash_cooldown.start()
		dash_active_timer.start()
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if dashActive == false:
		if is_on_floor():
			speed = SPRINT_SPEED
			
			if direction:
				walking = false
				velocity.x = direction.x * speed
				velocity.z = direction.z * speed
			else:
				walking = true
				velocity.x = 0.0
				velocity.z = 0.0
			
			if walking == true:
				walkingSound.play()
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 2.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 2.0)
			walkingSound.pitch_scale = 0.01
	
		#Head Bob
		t_bob += delta * velocity.length() * float(is_on_floor())
		head.transform.origin = _headbob(t_bob)
	
	#FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	move_and_slide()

#Head bob for movement
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos

#Attack Animation Reset
func _on_animation_player_animation_finished(anim_name: StringName):
	if anim_name == "attack":
		attackType = 1
		attackActive = false
		swordSound.stop()
		animationPlayer.play("idle")
		weapon_hitbox.monitoring = false
		attack_change_timer.start()
	if anim_name == "attack2":
		attackType = 2
		attackActive = false
		swordSound.stop()
		animationPlayer.play("idle")
		attack_change_timer.start()
		weapon_hitbox.monitoring = false
	if anim_name == "attack3":
		attackType = 0
		attackActive = false
		swordSound.stop()
		animationPlayer.play("idle")
		weapon_hitbox.monitoring = false
	if anim_name == "cast":
		instance = magic.instantiate()
		instance.position = arm_cast.global_position
		instance.transform.basis = arm_cast.global_transform.basis
		get_parent().add_child(instance)
		animationPlayer.play("idle")
		magicAttack = false

func _on_animation_player_animation_started(anim_name: StringName):
	if anim_name == "attack":
		swordSound.play()
		attackActive = true
		baseAttack = true
	if anim_name == "attack2":
		attack_change_timer.stop()
		attack_change_timer.wait_time = 0.35
		swordSound.play()
		attackActive = true
		baseAttack = true
	if anim_name == "attack3":
		swordSound.play()
		attackActive = true
		baseAttack = true
	if anim_name == "cast":
		cast_sound.play()
	if anim_name == "idle":
		baseAttack = false

func _on_attack_change_timeout() -> void:
	attackType = 0

#Enemy Collision with player and death
func _on_player_hitbox_area_entered(area):
	if area.is_in_group("enemy1") and iFrame == false:
		iFrame = true
		i_frame_timer.start()
		healthVin.show()
		vin_timer.start()
		if ARMOR > 0:
			ARMOR -= 15
		else:
			HEALTH -= 15
	if area.is_in_group("enemy2") and iFrame == false:
		iFrame = true
		i_frame_timer.start()
		healthVin.show()
		vin_timer.start()
		if ARMOR > 0:
			ARMOR -= 10
		else:
			HEALTH -= 10
	if area.is_in_group("enemy3") and iFrame == false:
		iFrame = true
		i_frame_timer.start()
		healthVin.show()
		vin_timer.start()
		if ARMOR > 0:
			ARMOR -= 20
		else:
			HEALTH -= 20
	if area.is_in_group("enemy4") and iFrame == false:
		iFrame = true
		i_frame_timer.start()
		healthVin.show()
		vin_timer.start()
		if ARMOR > 0:
			ARMOR -= 10
		else:
			HEALTH -= 10
	if area.is_in_group("enemy5") and iFrame == false:
		iFrame = true
		i_frame_timer.start()
		healthVin.show()
		vin_timer.start()
		if ARMOR > 0:
			ARMOR -= 20
		else:
			HEALTH -= 20
	if area.is_in_group("boss") and iFrame == false and boss_enemy_character.attackActive == true:
		iFrame = true
		i_frame_timer.start()
		healthVin.show()
		vin_timer.start()
		if ARMOR > 0:
			ARMOR -= 25
		else:
			HEALTH -= 25

func _on_i_frame_timer_timeout() -> void:
	iFrame = false

#Dash cooldown
func _on_dash_cooldown_timeout() -> void:
	dashCool = true

func _on_speed_timer_timeout() -> void:
	speed_lines.hide()

#Dash inactive
func _on_dash_active_timer_timeout() -> void:
	dashActive = false
	walkingSound.pitch_scale = 1.3

#Vignette reset
func _on_vin_timer_timeout() -> void:
	healthVin.hide()

#Gain points
func add_point():
	points += 1

#Player death
func death():
	if HEALTH <= 0:
		kill_all_enemies()
		#Reset player velocity
		velocity.x = 0
		velocity.z = 0
		#Reset player animation
		animationPlayer.play("idle")
		#Set player death
		world_environment.day_change_timer.stop()
		world_environment.night_time()
		playerDeath = true
		playerDeathSound.play()
		#Reset player position
		camera.rotation.x = 0.0
		head.rotation.y = 0.0
		if modeType == 0:
			player.transform.origin = graveyardPOS
		elif modeType == 1:
			player.transform.origin = shopPOS
		elif modeType == 2:
			player.transform.origin = bossRoomPOS
		#Show death menu
		deathMenu.show()
		healthVin.hide()
		uiOptionsDeath.grab_focus()
		startMenu.menuActive = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		#Reset player stats
		magicAttack = false
		if world.wave > 1:
			points = playerData.points
			souls = playerData.souls
			HEALTH = playerData.health
			ARMOR = playerData.armor
		else:
			points = 0
			souls = 0
			HEALTH = 100
			ARMOR = 0
		gameTimeSec = gameTimeSecDef
		gameTimeMin = gameTimeMinDef
		#Pause game
		get_tree().paused = true

#Wave end
func wave_end():
	if playerDeath == false:
		#Reset Player Speed
		velocity.x = 0
		velocity.z = 0
		#Reset Player animation
		animationPlayer.play("idle")
		#Declare player status and play sound
		playerDeath = true
		modeType = 1
		world.wave += 1
		playerDeathSound.play()
		#Set player position
		camera.rotation.x = 0.0
		head.rotation.y = 0.0
		player.transform.origin = shopPOS
		#Set Menu UI text
		pointsWave.text = "Demons Vanquished: " + str(points)
		soulsWave.text = "Souls Freed: " + str(souls)
		#Show menu and save data
		autosaveLabel.show()
		autosaveTextTimer.start()
		waveMenu.show()
		save()
		load_data()
		uiOptionsWave.grab_focus()
		startMenu.menuActive = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		#Reset game time
		gameTimeSec = gameTimeSecDef
		gameTimeMin = gameTimeMinDef
		#Set shop stage
		waveLabel.hide()
		timerLabel.hide()
		graveyard.hide()
		healthVin.hide()
		graveyard_other_textures.hide()
		all_enemies.hide()
		shop.show()
		get_tree().paused = true
		

func new_wave():
	if world.wave <= 10:
		#Reset player velocity
		velocity.x = 0
		velocity.z = 0
		#Reset player animation
		animationPlayer.play("idle")
		#Set player death
		playerDeath = true
		#Reset player position
		camera.rotation.x = 0.0
		head.rotation.y = 0.0
		player.transform.origin = graveyardPOS
		modeType = 0
		#Save stats for new wave
		save()
		load_data()
		#Show UI
		autosaveLabel.show()
		autosaveTextTimer.start()
		timerLabel.show()
		waveLabel.show()
	else:
		boss_battle()

#Boss battle change
func boss_battle():
	if playerDeath == false:
		#Reset Player Speed
		velocity.x = 0
		velocity.z = 0
		#Reset Player animation
		animationPlayer.play("idle")
		#Declare player status and play sound
		playerDeath = true
		modeType = 2
		#Set player position
		player.transform.origin = bossRoomPOS
		camera.rotation.x = 0.0
		head.rotation.y = 0.0
		#Set Menu UI text
		pointsWave.text = "Demons Vanquished: " + str(points)
		soulsWave.text = "Souls Freed: " + str(souls)
		#Show menu and save data
		boss_menu.show()
		save()
		load_data()
		uiOptionsBoss.grab_focus()
		startMenu.menuActive = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		#Reset game time
		gameTimeSec = gameTimeSecDef
		gameTimeMin = gameTimeMinDef
		#Reset Player stats
		HEALTH = 100
		#Set shop stage
		waveLabel.hide()
		timerLabel.hide()
		graveyard.hide()
		healthVin.hide()
		graveyard_other_textures.hide()
		all_enemies.hide()
		boss_room.show()
		get_tree().paused = true

#Game time increase
func _on_game_time_timeout() -> void:
	if modeType == 0:
		#Handle wave end
		if gameTimeMin == 0 and gameTimeSec == 0:
			gameTimeChange = 0
			timerLabel.hide()
			world_environment.sun_rise()
		else:
			gameTimeChange = 1
		#Handle wave countdown
		if gameTimeMin > 0 and gameTimeSec <= 0:
			gameTimeSec = 60
			gameTimeMin -= 1
		
		gameTimeSec -= gameTimeChange

func _on_replay_timer_timeout() -> void:
	playerDeath = false

#Player Highscore save
func _ready():
	if DirAccess.dir_exists_absolute(direct_file_path):
		load_data()
	else:
		verify_save_directory(save_file_path)
		save()
		load_data()

func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)

func load_data():
	kill_all_enemies()
	camera.rotation.x = 0.0
	head.rotation.y = 0.0
	
	playerData = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)
	points = playerData.points
	bossKills = playerData.bossKills
	souls = playerData.souls
	world.wave = playerData.wave
	HEALTH = playerData.health
	playerAttack = playerData.playerAttack
	playerMagicAtk = playerData.playerMagicAtk
	SPELL = playerData.spell
	ARMOR = playerData.armor
	maxArmor = playerData.maxArmor
	UPGRADE = playerData.upgrade
	modeType = playerData.modeType
	fireSpell = playerData.fireSpell
	iceSpell = playerData.iceSpell
	lightningSpell = playerData.lightningSpell
	player.position = playerData.POS
	playerMagicRegen = playerData.playerMagicRegen
	
	if modeType == 0:
		player.position = graveyardPOS
		graveyard.show()
		graveyard_other_textures.show()
		all_enemies.show()
		playerDeath = false
		shop.hide()
		boss_room.hide()
		boss_enemy_character.hide()
	elif modeType == 1:
		player.position = shopPOS
		graveyard.hide()
		graveyard_other_textures.hide()
		all_enemies.hide()
		waveLabel.hide()
		timerLabel.hide()
		playerDeath = true
		boss_room.hide()
		boss_enemy_character.hide()
		shop.show()
	elif modeType == 2:
		player.position = bossRoomPOS
		graveyard.hide()
		graveyard_other_textures.hide()
		all_enemies.hide()
		waveLabel.hide()
		timerLabel.hide()
		shop.hide()
		playerDeath = true
		boss_room.show()
		boss_enemy_character.show()

func save():
	playerData.points = points
	playerData.souls = souls
	playerData.wave = world.wave
	playerData.health = HEALTH
	playerData.playerAttack = playerAttack
	playerData.playerMagicAtk = playerMagicAtk
	playerData.spell = SPELL
	playerData.armor = ARMOR
	playerData.upgrade = UPGRADE
	playerData.modeType = modeType
	playerData.POS = player.position
	playerData.fireSpell = fireSpell
	playerData.lightningSpell = lightningSpell
	playerData.iceSpell = iceSpell
	playerData.playerMagicRegen = playerMagicRegen
	playerData.maxArmor = maxArmor
	playerData.bossKills = bossKills
	ResourceSaver.save(playerData, save_file_path + save_file_name)

func save_boss_kills():
	playerData.bossKills = bossKills
	ResourceSaver.save(playerData, save_file_path + save_file_name)

func stat_reset():
	points = 0
	souls = 0
	world.wave = 1
	HEALTH = 100
	playerAttack = 25
	playerMagicAtk = 50
	SPELL = 0
	fireSpell = 0
	lightningSpell = 0
	iceSpell = 0
	ARMOR = 0
	maxArmor = 50
	UPGRADE = 0
	modeType = 0
	playerMagicRegen = 0.2
	player.position = graveyardPOS
	camera.global_rotation = Vector3.ZERO
	
	if modeType == 0:
		graveyard.show()
		graveyard_other_textures.show()
		all_enemies.show()
		waveLabel.show()
		timerLabel.show()
		playerDeath = false
		shop.hide()
	elif modeType == 1:
		graveyard.hide()
		graveyard_other_textures.hide()
		all_enemies.hide()
		waveLabel.hide()
		timerLabel.hide()
		playerDeath = true
		shop.show()

func _on_timer_timeout() -> void:
	autosaveLabel.hide()

func kill_all_enemies():
	for enemy in get_tree().get_nodes_in_group("enemySet"):
		enemy.queue_free()
