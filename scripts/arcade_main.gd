extends Node3D

@onready var spawns: Node3D = $spawns
@onready var navigation_region: NavigationRegion3D = $NavigationRegion3D
@onready var player: CharacterBody3D = $player
@onready var respawnTimerDemon: Timer = $allEnemies/spawnTimerDemon1
@onready var respawnTimerDemon2: Timer = $allEnemies/spawnTimerDemon2
@onready var respawnTimerDemon3: Timer = $allEnemies/spawnTimerDemon3
@onready var respawnTimerDemon4: Timer = $allEnemies/spawnTimerDemon4
@onready var respawnTimerDemon5: Timer = $allEnemies/spawnTimerDemon5
@onready var wave_label: Label = $UI/waveUI/VBoxContainer/waveLabel
@onready var world_environment: WorldEnvironment = $WorldEnvironment
@onready var text_levelLabel: Label = $UI/anounceText/VBoxContainer/textLevel
@onready var text_healLabel: Label = $UI/anounceText/VBoxContainer/textHeal
@onready var spell_unlockLabel: Label = $UI/anounceText/VBoxContainer/spellUnlock
@onready var sword_unlockLabel: Label = $UI/anounceText/VBoxContainer/swordUnlock
@onready var level_timer: Timer = $UI/anounceText/levelTimer
@onready var heal_timer: Timer = $UI/anounceText/healTimer
@onready var spell_timer: Timer = $UI/anounceText/spellTimer
@onready var sword_timer: Timer = $UI/anounceText/swordTimer
@onready var heal_sound: AudioStreamPlayer = $sounds/healSound
@onready var level_sound: AudioStreamPlayer = $sounds/levelSound

var lightningMagic = preload("res://scenes/lightning_magic.tscn")
var beamMagic = preload("res://scenes/beam_magic.tscn")
var iceMagic = preload("res://scenes/ice_magic.tscn")
var demonMagic = preload("res://scenes/demon_magic.tscn")
var bossMagic = preload("res://scenes/boss_magic.tscn")

var demon = preload("res://scenes/enemy1.tscn")
var demon2 = preload("res://scenes/enemy2.tscn")
var demon3 = preload("res://scenes/enemy3.tscn")
var demon4 = preload("res://scenes/enemy4.tscn")
var demon5 = preload("res://scenes/enemy5.tscn")
var instance
var wave: int = 1
var spawnDecrease: float = 0.1
var demon1SpawnTime: float = 3.0
var demon2SpawnTime: float = 6.0
var demon3SpawnTime: float = 10.0
var demon4SpawnTime: float = 8.0
var demon5SpawnTime: float = 12.0
var dec200: float = 0.95
var dec400: float = 0.90
var dec600: float = 0.85
var maxSpawn: int = 6
var spawnValid: bool = true
var gameEnd = false
var playerHeal: int = 0
var unlock: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()

func _process(_delta: float) -> void:
	
	wave_label.text = "Night: " + str(wave)
	demon_spawn_dec()
	demon2_spawn_dec()
	demon3_spawn_dec()
	demon4_spawn_dec()
	
	match player.gameTimeMin:
		8: 
			if unlock == 3:
				maxSpawn = 13
				player.UPGRADE = 1
				player.playerAttack = 50
				player.playerMagicAtk = 75
				player.playerMagicRegen = 0.50
				text_levelLabel.show()
				sword_unlockLabel.show()
				level_timer.start()
				sword_timer.start()
				level_sound.play()
				unlock = 4
		7: 
			maxSpawn = 12
		6: 
			if unlock == 2:
				maxSpawn = 11
				player.lightningSpell = 1
				player.playerAttack = 40
				player.playerMagicAtk = 65
				player.playerMagicRegen = 0.40
				text_levelLabel.show()
				spell_unlockLabel.show()
				level_timer.start()
				spell_timer.start()
				level_sound.play()
				unlock = 3
		5: 
			maxSpawn = 10
		4: 
			if unlock == 1:
				maxSpawn = 9
				player.fireSpell = 1
				player.playerAttack = 35
				player.playerMagicAtk = 60
				player.playerMagicRegen = 0.35
				text_levelLabel.show()
				spell_unlockLabel.show()
				level_timer.start()
				spell_timer.start()
				level_sound.play()
				unlock = 2
		3: 
			maxSpawn = 8
		2: 
			if unlock == 0:
				maxSpawn = 7
				player.iceSpell = 1
				player.SPELL = 1
				player.playerAttack = 30
				player.playerMagicAtk = 55
				player.playerMagicRegen = 0.30
				text_levelLabel.show()
				spell_unlockLabel.show()
				level_timer.start()
				spell_timer.start()
				level_sound.play()
				unlock = 1
		_: 
			maxSpawn = 6
			wave = 10
	
	match player.points:
		250:
			if playerHeal == 4:
				player.HEALTH += 100
				player.maxArmor = 100
				player.ARMOR += 100
				text_healLabel.show()
				heal_timer.start()
				heal_sound.play()
				playerHeal = 5
		200:
			if playerHeal == 3:
				player.HEALTH += 100
				player.maxArmor = 75
				player.ARMOR += 75
				text_healLabel.show()
				heal_timer.start()
				heal_sound.play()
				playerHeal = 4
		150:
			if playerHeal == 2:
				player.HEALTH += 100
				player.ARMOR += 50
				text_healLabel.show()
				heal_timer.start()
				heal_sound.play()
				playerHeal = 3
		100:
			if playerHeal == 1:
				player.HEALTH += 100
				text_healLabel.show()
				heal_timer.start()
				heal_sound.play()
				playerHeal = 2
		50:
			if playerHeal == 0:
				player.HEALTH += 50
				text_healLabel.show()
				heal_timer.start()
				heal_sound.play()
				playerHeal = 1
		_:
			pass
	
	var spawnCount = get_tree().get_nodes_in_group("enemySet").size()
	if spawnCount >= maxSpawn:
		spawnValid = false
	else:
		spawnValid = true
	
	if player.playerDeath == true:
		match wave:
			_: 
				player.gameTimeSec = 0
				player.gameTimeMin = 0
				player.gameTimeSecDef = 0
				player.gameTimeMinDef = 0

#Enemy 1 Spawning
func _get_random_child(parent_node):
	var random_id = randi() % parent_node.get_child_count()
	return parent_node.get_child(random_id)

func _on_spawn_timer_timeout() -> void:
	if spawnValid == true and player.modeType == 0:
		var spawn_point = _get_random_child(spawns).global_position
		instance = demon.instantiate()
		instance.position = spawn_point
		navigation_region.add_child(instance)
		instance.add_to_group("enemySet")
		respawnTimerDemon.start()

func _on_spawn_timer_demon_2_timeout() -> void:
	if player.gameTimeMin >= 1 and spawnValid == true and player.modeType == 0:
		var spawn_point = _get_random_child(spawns).global_position
		instance = demon2.instantiate()
		instance.position = spawn_point
		navigation_region.add_child(instance)
		instance.add_to_group("enemySet")
		respawnTimerDemon2.start()

func _on_spawn_timer_demon_3_timeout() -> void:
	if player.gameTimeMin >= 3 and spawnValid == true and player.modeType == 0:
		var spawn_point = _get_random_child(spawns).global_position
		instance = demon3.instantiate()
		instance.position = spawn_point
		navigation_region.add_child(instance)
		instance.add_to_group("enemySet")
		respawnTimerDemon3.start()

func _on_spawn_timer_demon_4_timeout() -> void:
	if player.gameTimeMin >= 5 and spawnValid == true and player.modeType == 0:
		var spawn_point = _get_random_child(spawns).global_position
		instance = demon4.instantiate()
		instance.position = spawn_point
		navigation_region.add_child(instance)
		instance.add_to_group("enemySet")
		respawnTimerDemon4.start()

func _on_spawn_timer_demon_5_timeout() -> void:
	if player.gameTimeMin >= 7 and spawnValid == true and player.modeType == 0:
		var spawn_point = _get_random_child(spawns).global_position
		instance = demon5.instantiate()
		instance.position = spawn_point
		navigation_region.add_child(instance)
		instance.add_to_group("enemySet")
		respawnTimerDemon5.start()

func demon_spawn_dec():
	if player.gameTimeMin > 6:
		respawnTimerDemon.wait_time = demon1SpawnTime * dec600
	elif player.gameTimeMin > 4:
		respawnTimerDemon.wait_time = demon1SpawnTime * dec400
	elif player.gameTimeMin > 2:
		respawnTimerDemon.wait_time = demon1SpawnTime * dec200
	else:
		respawnTimerDemon.wait_time = demon1SpawnTime

func demon2_spawn_dec():
	if player.gameTimeMin > 6:
		respawnTimerDemon2.wait_time = demon2SpawnTime * dec400
	elif player.gameTimeMin > 4:
		respawnTimerDemon2.wait_time = demon2SpawnTime * dec200
	else:
		respawnTimerDemon2.wait_time = demon2SpawnTime

func demon3_spawn_dec():
	if player.gameTimeMin > 8:
		respawnTimerDemon3.wait_time = demon3SpawnTime * dec400
	elif player.gameTimeMin > 6:
		respawnTimerDemon3.wait_time = demon3SpawnTime * dec200
	else:
		respawnTimerDemon3.wait_time = demon3SpawnTime

func demon4_spawn_dec():
	if player.gameTimeMin > 8:
		respawnTimerDemon4.wait_time = demon4SpawnTime * dec200
	else:
		respawnTimerDemon4.wait_time = demon4SpawnTime


func _on_level_timer_timeout() -> void:
	text_levelLabel.hide()

func _on_heal_timer_timeout() -> void:
	text_healLabel.hide()

func _on_spell_timer_timeout() -> void:
	spell_unlockLabel.hide()

func _on_sword_timer_timeout() -> void:
	sword_unlockLabel.hide()
