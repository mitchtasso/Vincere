extends Node3D

@onready var spawns = $spawns
@onready var navigation_region = $NavigationRegion3D
@onready var player = $player
@onready var respawnTimerDemon = $allEnemies/spawnTimerDemon1
@onready var respawnTimerDemon2 = $allEnemies/spawnTimerDemon2
@onready var respawnTimerDemon3 = $allEnemies/spawnTimerDemon3
@onready var respawnTimerDemon4 = $allEnemies/spawnTimerDemon4
@onready var wave_label: Label = $UI/waveUI/VBoxContainer/waveLabel
@onready var world_environment: WorldEnvironment = $WorldEnvironment

var demon = load("res://scenes/enemy1.tscn")
var demon2 = load("res://scenes/enemy2.tscn")
var demon3 = load("res://scenes/enemy3.tscn")
var demon4 = load("res://scenes/enemy4.tscn")
var instance
var wave = 1
var spawnDecrease = 0.1
var demon1SpawnTime = 3.0
var demon2SpawnTime = 5.0
var demon3SpawnTime = 10.0
var demon4SpawnTime = 8.0
var dec200 = 0.95
var dec400 = 0.90
var dec600 = 0.85
var inc777 = 1.5
var maxSpawn = 6
var spawnValid = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()

func _process(_delta: float) -> void:
	wave_label.text = "Wave: " + str(wave)
	demon_spawn_dec()
	demon2_spawn_dec()
	demon3_spawn_dec()
	demon4_spawn_dec()
	
	match wave:
		10: maxSpawn = 14
		9: maxSpawn = 14
		8: maxSpawn = 12
		7: maxSpawn = 12
		6: maxSpawn = 10
		5: maxSpawn = 10
		4: maxSpawn = 8
		3: maxSpawn = 8
		2: maxSpawn = 6
		_: maxSpawn = 6
	
	var spawnCount = get_tree().get_nodes_in_group("enemySet").size()
	if spawnCount >= maxSpawn:
		spawnValid = false
	else:
		spawnValid = true
	
	if player.playerDeath == true:
		if wave > 6:
			player.gameTimeSec = 0
			player.gameTimeMin = 3
			player.gameTimeSecDef = 0
			player.gameTimeMinDef = 3
		elif wave > 4:
			player.gameTimeSec = 30
			player.gameTimeMin = 2
			player.gameTimeSecDef = 30
			player.gameTimeMinDef = 2
		elif wave > 2:
			player.gameTimeSec = 0
			player.gameTimeMin = 2
			player.gameTimeSecDef = 0
			player.gameTimeMinDef = 2
		else:
			player.gameTimeSec = 30
			player.gameTimeMin = 1
			player.gameTimeSecDef = 30
			player.gameTimeMinDef = 1

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
	if wave > 2 and spawnValid == true and player.modeType == 0:
		var spawn_point = _get_random_child(spawns).global_position
		instance = demon2.instantiate()
		instance.position = spawn_point
		navigation_region.add_child(instance)
		instance.add_to_group("enemySet")
		respawnTimerDemon2.start()

func _on_spawn_timer_demon_3_timeout() -> void:
	if wave > 4 and spawnValid == true and player.modeType == 0:
		var spawn_point = _get_random_child(spawns).global_position
		instance = demon3.instantiate()
		instance.position = spawn_point
		navigation_region.add_child(instance)
		instance.add_to_group("enemySet")
		respawnTimerDemon3.start()

func _on_spawn_timer_demon_4_timeout() -> void:
	if wave > 6 and spawnValid == true and player.modeType == 0:
		var spawn_point = _get_random_child(spawns).global_position
		instance = demon4.instantiate()
		instance.position = spawn_point
		navigation_region.add_child(instance)
		instance.add_to_group("enemySet")
		respawnTimerDemon4.start()


func demon_spawn_dec():
	if wave > 6:
		respawnTimerDemon.wait_time = demon1SpawnTime * dec600
	elif wave > 4:
		respawnTimerDemon.wait_time = demon1SpawnTime * dec400
	elif wave > 2:
		respawnTimerDemon.wait_time = demon1SpawnTime * dec200
	else:
		respawnTimerDemon.wait_time = demon1SpawnTime

func demon2_spawn_dec():
	if wave > 6:
		respawnTimerDemon2.wait_time = demon2SpawnTime * dec400
	elif wave > 4:
		respawnTimerDemon2.wait_time = demon2SpawnTime * dec200
	else:
		respawnTimerDemon2.wait_time = demon2SpawnTime

func demon3_spawn_dec():
	if wave > 6:
		respawnTimerDemon3.wait_time = demon3SpawnTime * dec200
	else:
		respawnTimerDemon3.wait_time = demon3SpawnTime

func demon4_spawn_dec():
	if wave > 8:
		respawnTimerDemon4.wait_time = demon4SpawnTime * dec200
	else:
		respawnTimerDemon4.wait_time = demon4SpawnTime
