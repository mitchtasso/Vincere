extends Control

var resolution: int = 3
var window: int = 0
var vsync: int = 1
var fpsCount: int = 1
var FPS
var resolutionScale: float = 100

@onready var VideoMenu: Control = $"."
@onready var buttonSound: AudioStreamPlayer = $"../../sounds/menuButton"
@onready var resolutionBox: OptionButton = $MarginContainer/VBoxContainer/resolution
@onready var windowBox: OptionButton = $MarginContainer/VBoxContainer/window
@onready var vsyncBox: OptionButton = $MarginContainer/VBoxContainer/vsync
@onready var fpsBox: OptionButton = $MarginContainer/VBoxContainer/fps
@onready var fpsUI: Label = $"../playerUI/VBoxContainer/fps"
@onready var savedText: MarginContainer = $savedText
@onready var tempTextTimer: Timer = $tempText
@onready var resText: Label = $MarginContainer/VBoxContainer/title6
@onready var res_scale: HSlider = $MarginContainer/VBoxContainer/resScale

@onready var OptionsMenu: Control = $"../OptionsMenu"
@onready var OptionsMenuSelect: Button = $"../OptionsMenu/buttons/VBoxContainer/controls"

var settingsData = SettingsData.new()
var save_file_path: String = "user://VincereData/Settings/"
var save_file_name: String = "SettingData.tres"
var direct_file_path: String = "user://VincereData/Settings/"

func _physics_process(_delta: float) -> void:
	resText.text = "Resolution Scale: " + str(res_scale.value) + "%"

func _on_back_pressed():
	buttonSound.play()
	load_data()
	VideoMenu.hide()
	OptionsMenu.show()
	OptionsMenuSelect.grab_focus()

func _on_window_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			window = 0
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			window = 1

func _on_resolution_item_selected(index):
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(2560,1440))
			resolution = 0
		1:
			DisplayServer.window_set_size(Vector2i(1920,1080))
			resolution = 1
		2:
			DisplayServer.window_set_size(Vector2i(1600,900))
			resolution = 2
		3:
			DisplayServer.window_set_size(DisplayServer.screen_get_size())
			resolution = 3

func _on_vsync_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
			vsync = 0
		1:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
			vsync = 1

func _on_fps_item_selected(index: int) -> void:
	match index:
		0:
			fpsCount = 0
		1:
			fpsCount = 1

func _ready():
	if DirAccess.dir_exists_absolute(direct_file_path):
		load_data()
	else:
		verify_save_directory(save_file_path)
		save()

func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)

func load_data():
	settingsData = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)
	resolution = settingsData.resolution
	window = settingsData.window
	vsync = settingsData.vsync
	fpsCount = settingsData.fpsCount
	resolutionScale = settingsData.resolutionScale
	
	windowBox.selected = window
	if windowBox.selected == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif windowBox.selected == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	resolutionBox.selected = resolution
	if resolutionBox.selected == 0:
		DisplayServer.window_set_size(Vector2i(2560,1440))
	elif resolutionBox.selected == 1:
		DisplayServer.window_set_size(Vector2i(1920,1080))
	elif resolutionBox.selected == 2:
		DisplayServer.window_set_size(Vector2i(1600,900))
	elif resolutionBox.selected == 3:
		DisplayServer.window_set_size(DisplayServer.screen_get_size())
	
	vsyncBox.selected = vsync
	if vsyncBox.selected == 0:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	elif vsyncBox.selected == 1:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	
	res_scale.value = resolutionScale
	get_viewport().set_scaling_3d_scale(resolutionScale/100)
	
	fpsBox.selected = fpsCount
	if fpsBox.selected == 0:
		FPS = "FPS: " + str(Engine.get_frames_per_second())
	elif fpsBox.selected == 1:
		FPS = ""

func save():
	savedText.show()
	tempTextTimer.start()
	settingsData.fpsCount = fpsCount
	settingsData.resolution = resolution
	settingsData.window = window
	settingsData.vsync = vsync
	settingsData.resolutionScale = resolutionScale
	ResourceSaver.save(settingsData, save_file_path + save_file_name)
	
func _on_save_pressed() -> void:
	buttonSound.play()
	save()

func _process(_delta):
	if settingsData.fpsCount == 0:
		FPS = "FPS: " + str(Engine.get_frames_per_second())
	elif settingsData.fpsCount == 1:
		FPS = ""
	fpsUI.text = FPS

func _on_temp_text_timeout() -> void:
	savedText.hide()

func _on_res_scale_value_changed(value: float) -> void:
	resolutionScale = res_scale.value
	get_viewport().set_scaling_3d_scale(resolutionScale/100)
