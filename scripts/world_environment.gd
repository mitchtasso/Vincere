extends WorldEnvironment

var enviro = Environment.new()
var sky = Sky.new()
var proSky = ProceduralSkyMaterial.new()
@onready var worldEnvironment: WorldEnvironment = $"."
@onready var sun: DirectionalLight3D = $"../sun"
@onready var player: CharacterBody3D = $"../player"
@onready var day_change_timer: Timer = $"../dayChangeTimer"

var dayChange: bool = false

func _process(_delta: float) -> void:
	
	if dayChange == false:
		if player.modeType == 0:
			night_time()
		elif player.modeType == 1:
			day_time()
		elif player.modeType == 2:
			night_time()

func sun_rise():
	dayChange = true
	player.playerDeath = true
	proSky.sky_top_color = Color(0.03, 0.218, 0.339)
	proSky.sky_horizon_color = Color(0.581, 0.371, 0.104)
	proSky.sky_curve = 0.144
	proSky.ground_bottom_color = Color.hex(000000)
	proSky.ground_horizon_color = Color(0.168, 0.173, 0.181)
	sky.sky_material = proSky
	enviro.sky = sky
	enviro.background_mode = Environment.BG_SKY
	worldEnvironment.environment = enviro
	sun.light_energy = 0.5
	day_change_timer.start()

func day_time():
	proSky.sky_top_color = Color(0.076, 0.364, 0.55)
	proSky.sky_horizon_color = Color(0.168, 0.173, 0.181)
	proSky.sky_curve = 0.0174
	proSky.ground_bottom_color = Color.hex(000000)
	proSky.ground_horizon_color = Color(0.168, 0.173, 0.181)
	sky.sky_material = proSky
	enviro.sky = sky
	enviro.fog_enabled = false
	enviro.background_mode = Environment.BG_SKY
	worldEnvironment.environment = enviro
	sun.light_energy = 1.25

func night_time():
	proSky.sky_top_color = Color.hex(000000)
	proSky.sky_curve = 0.0174
	proSky.sky_horizon_color = Color(0.168, 0.173, 0.181)
	proSky.ground_bottom_color = Color.hex(000000)
	proSky.ground_horizon_color = Color(0.168, 0.173, 0.181)
	sky.sky_material = proSky
	enviro.sky = sky
	enviro.fog_enabled = true
	enviro.fog_light_color = Color(0.72, 0.72, 0.72)
	enviro.fog_light_energy = 0.1
	enviro.fog_density = 0.05
	enviro.background_mode = Environment.BG_SKY
	worldEnvironment.environment = enviro
	sun.light_energy = 0.175

func _on_day_change_timer_timeout() -> void:
	player.playerDeath = false
	dayChange = false
	player.wave_end()
