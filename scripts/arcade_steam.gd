extends Node3D

@onready var world: Node3D = $".."
@onready var player: CharacterBody3D = $"../player"

var AppID = "3416040"
var isRunning

func _init() -> void:
	OS.set_environment("SteamAppID", AppID)
	OS.set_environment("SteamGameID", AppID)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Steam.steamInit()

func _process(_delta: float) -> void:
	isRunning = Steam.isSteamRunning()
	if isRunning:
		
		if player.points >= 200:
			setAchievement("ACH_SLAYER")
		
		if player.gameTimeMin >= 8:
			setAchievement("ACH_TIME")
		
		if player.playerData.gameTimeMin > 0 or player.playerData.gameTimeSec > 0:
			setAchievement("ACH_NIGHT")
		
	else:
		pass

func setAchievement(ach):
	var status = Steam.getAchievement(ach)
	if status["achieved"]:
		return
	Steam.setAchievement(ach)
	Steam.storeStats()
