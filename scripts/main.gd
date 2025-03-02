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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()

func _process(_delta: float) -> void:
	
	wave_label.text = "Night: " + str(wave)
	demon_spawn_dec()
	demon2_spawn_dec()
	demon3_spawn_dec()
	demon4_spawn_dec()
	
	match wave:
		10: maxSpawn = 13
		9: maxSpawn = 12
		8: maxSpawn = 11
		7: maxSpawn = 10
		6: maxSpawn = 9
		5: maxSpawn = 8
		4: maxSpawn = 7
		3: maxSpawn = 6
		2: maxSpawn = 5
		_: maxSpawn = 4
	
	var spawnCount = get_tree().get_nodes_in_group("enemySet").size()
	if spawnCount >= maxSpawn:
		spawnValid = false
	else:
		spawnValid = true
	
	if player.playerDeath == true:
		match wave:
			10: 
				player.gameTimeSec = 0
				player.gameTimeMin = 5
				player.gameTimeSecDef = 0
				player.gameTimeMinDef = 5
			9: 
				player.gameTimeSec = 0
				player.gameTimeMin = 4
				player.gameTimeSecDef = 0
				player.gameTimeMinDef = 4
			8: 
				player.gameTimeSec = 45
				player.gameTimeMin = 3
				player.gameTimeSecDef = 45
				player.gameTimeMinDef = 3
			7: 
				player.gameTimeSec = 30
				player.gameTimeMin = 3
				player.gameTimeSecDef = 30
				player.gameTimeMinDef = 3
			6: 
				player.gameTimeSec = 15
				player.gameTimeMin = 3
				player.gameTimeSecDef = 15
				player.gameTimeMinDef = 3
			5: 
				player.gameTimeSec = 0
				player.gameTimeMin = 3
				player.gameTimeSecDef = 0
				player.gameTimeMinDef = 3
			4: 
				player.gameTimeSec = 45
				player.gameTimeMin = 2
				player.gameTimeSecDef = 45
				player.gameTimeMinDef = 2
			3: 
				player.gameTimeSec = 30
				player.gameTimeMin = 2
				player.gameTimeSecDef = 30
				player.gameTimeMinDef = 2
			2: 
				player.gameTimeSec = 15
				player.gameTimeMin = 2
				player.gameTimeSecDef = 15
				player.gameTimeMinDef = 2
			_: 
				player.gameTimeSec = 0
				player.gameTimeMin = 2
				player.gameTimeSecDef = 0
				player.gameTimeMinDef = 2


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

func _on_spawn_timer_demon_5_timeout() -> void:
	if wave > 8 and spawnValid == true and player.modeType == 0:
		var spawn_point = _get_random_child(spawns).global_position
		instance = demon5.instantiate()
		instance.position = spawn_point
		navigation_region.add_child(instance)
		instance.add_to_group("enemySet")
		respawnTimerDemon5.start()

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
	if wave > 8:
		respawnTimerDemon3.wait_time = demon3SpawnTime * dec400
	elif wave > 6:
		respawnTimerDemon3.wait_time = demon3SpawnTime * dec200
	else:
		respawnTimerDemon3.wait_time = demon3SpawnTime

func demon4_spawn_dec():
	if wave > 8:
		respawnTimerDemon4.wait_time = demon4SpawnTime * dec200
	else:
		respawnTimerDemon4.wait_time = demon4SpawnTime
