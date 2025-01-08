extends Control

var volume = 0

@onready var AudioMenu = $"."
@onready var buttonSound = $"../../sounds/menuButton"
@onready var volumeBar = $MarginContainer/VBoxContainer/volume
@onready var savedText = $savedText
@onready var tempTextTimer = $tempText

@onready var OptionsMenu = $"../OptionsMenu"
@onready var OptionsMenuSelect = $"../OptionsMenu/buttons/VBoxContainer/back"

var settingsData = SettingsData.new()
var save_file_path = "user://VincereSaves/Settings/"
var save_file_name = "SettingData.tres"
var direct_file_path = "user://VincereSaves/Settings/"

func _on_back_pressed():
	buttonSound.play()
	load_data()
	AudioMenu.hide()
	OptionsMenu.show()
	OptionsMenuSelect.grab_focus()

func _on_volume_value_changed(value: float) -> void:
	volume = value
	AudioServer.set_bus_volume_db(0, volume)

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
	volume = settingsData.volumeLevel
	
	volumeBar.value = volume
	AudioServer.set_bus_volume_db(0, volume)

func save():
	savedText.show()
	tempTextTimer.start()
	settingsData.volumeLevel = volume
	ResourceSaver.save(settingsData, save_file_path + save_file_name)
	
func _on_save_pressed() -> void:
	buttonSound.play()
	save()

func _on_temp_text_timeout() -> void:
	savedText.hide()
