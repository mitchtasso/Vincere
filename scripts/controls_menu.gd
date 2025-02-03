extends Control

@onready var ControlsMenu: Control = $"."
@onready var buttonSound: AudioStreamPlayer = $"../../sounds/menuButton"

@onready var OptionsMenu: Control = $"../OptionsMenu"
@onready var OptionsMenuSelect: Button = $"../OptionsMenu/buttons/VBoxContainer/controls"
@onready var m_level: Label = $MarginContainer2/VBoxContainer/mLevel
@onready var h_level: Label = $MarginContainer2/VBoxContainer/hLevel
@onready var v_level: Label = $MarginContainer2/VBoxContainer/vLevel
@onready var vertical_slider: HSlider = $MarginContainer2/VBoxContainer/verticalSlider
@onready var horiz_slider: HSlider = $MarginContainer2/VBoxContainer/horizSlider
@onready var mouse_slider: HSlider = $MarginContainer2/VBoxContainer/mouseSlider
@onready var saved_text: MarginContainer = $savedText
@onready var timer: Timer = $Timer

var settingsData = SettingsData.new()
var save_file_path: String = "user://VincereSaves/Settings/"
var save_file_name: String = "SettingData.tres"
var direct_file_path: String = "user://VincereSaves/Settings/"

var horizSens: float = 50.0
var verticalSens: float = 50.0
var mouseSens: float = 50.0

func _ready() -> void:
	
	if DirAccess.dir_exists_absolute(direct_file_path):
		load_data()
	else:
		verify_save_directory(save_file_path)
		save()
		load_data()

func _on_back_pressed():
	load_data()
	buttonSound.play()
	ControlsMenu.hide()
	OptionsMenu.show()
	OptionsMenuSelect.grab_focus()

func _on_save_button_pressed() -> void:
	save()

func _on_vertical_slider_value_changed(value: float) -> void:
	verticalSens = value
	v_level.text = str(verticalSens)

func _on_horiz_slider_value_changed(value: float) -> void:
	horizSens = value
	h_level.text = str(horizSens)

func _on_mouse_slider_value_changed(value: float) -> void:
	mouseSens = value
	m_level.text = str(mouseSens)

func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)

func load_data():
	settingsData = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)
	
	verticalSens = settingsData.controllerSensV
	horizSens = settingsData.controllerSensH
	mouseSens = settingsData.mouseSens
	
	vertical_slider.value = verticalSens
	horiz_slider.value = horizSens
	mouse_slider.value = mouseSens
	
	v_level.text = str(verticalSens)
	h_level.text = str(horizSens)
	m_level.text = str(mouseSens)

func save():
	settingsData.controllerSensH = horizSens
	settingsData.controllerSensV = verticalSens
	settingsData.mouseSens = mouseSens
	
	v_level.text = str(settingsData.controllerSensV)
	h_level.text = str(settingsData.controllerSensH)
	m_level.text = str(settingsData.mouseSens)
	
	ResourceSaver.save(settingsData, save_file_path + save_file_name)
	buttonSound.play()
	saved_text.show()
	timer.start()

func _on_timer_timeout() -> void:
	saved_text.hide()
