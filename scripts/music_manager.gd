extends Node

@onready var game_music: AudioStreamPlayer = $"../GameMusic"
@onready var player: CharacterBody3D = $"../../player"

var shopMusic = load("res://sounds/eerieGameMusic.wav")
var graveyardMusic = load("res://sounds/retro/darkbeat.wav")
var bossMusic = load("res://sounds/coolJam1.wav")
var musicStream = AudioStream.new()
var graveActive: int = 0
var shopActive: int = 0
var bossActive: int = 0

func _process(_delta: float) -> void:
	
	if player.modeType == 0 and graveActive == 0:
		game_music.set_stream(graveyardMusic)
		game_music.playing = true
		graveActive = 1
		shopActive = 0
		bossActive = 0
	if player.modeType == 1 and shopActive == 0:
		game_music.set_stream(shopMusic)
		game_music.playing = true
		shopActive = 1
		bossActive = 0
		graveActive = 0
	if player.modeType == 2 and bossActive == 0:
		game_music.set_stream(bossMusic)
		game_music.playing = true
		bossActive = 1
		graveActive = 0
		shopActive = 0
