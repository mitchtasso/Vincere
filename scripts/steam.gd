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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	isRunning = Steam.isSteamRunning()
	
	if isRunning:
		
		if player.points >= 500:
			setAchievement("ACH_VANQUISH")
		else:
			pass
		
		if player.playerData.fireSpell == 1 and player.playerData.lightningSpell == 1 and player.playerData.iceSpell == 1:
			setAchievement("ACH_MAXSPELLS")
		else:
			pass
		
		if player.bossKills > 0:
			setAchievement("ACH_BOSS")
		else:
			pass
		
		if player.playerData.upgrade > 0:
			setAchievement("ACH_LONGSWORD")
		else:
			pass
		
		if player.playerData.playerMagicAtk >= 75:
			setAchievement("ACH_MAXMAGIC")
		else:
			pass
		
		if player.playerData.maxArmor >= 100:
			setAchievement("ACH_MAXARMOR")
		else:
			pass
	else:
		pass

func setAchievement(ach):
	var status = Steam.getAchievement(ach)
	if status["achieved"]:
		return
	Steam.setAchievement(ach)
	Steam.storeStats()
