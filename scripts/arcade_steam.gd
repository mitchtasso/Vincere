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
