extends CanvasGroup

@onready var phone_panel: Panel = $Phone

@onready var main_app: Panel = $Phone/Main
@onready var navigation_panel: Panel = $Phone/Navigation
@onready var tutorial_app: Panel = $Phone/Tutorial_App
@onready var map_app: Panel = $Phone/Map_App
@onready var work_app: Panel = $Phone/Work_App
@onready var notes_app: Panel = $Phone/Notes_App
@onready var sms_app: Panel = $Phone/Sms_App
@onready var settings_app: Panel = $Phone/Settings_App

@onready var current_app: Panel = main_app


# Settings
@onready var music_level: Label = $Phone/Settings_App/Buttons/HBoxContainer/Control/CenterContainer/Music_Level
@onready var sfx_level: Label = $Phone/Settings_App/Buttons/HBoxContainer2/Control/CenterContainer/SFX_Level
@onready var extra_ui: Control = $Extra_UI
var music_volum := 0.5
var sfx_volum := 0.5
var bus_music: = AudioServer.get_bus_index("Music")
var bus_sfx: = AudioServer.get_bus_index("SFX")

var _phone: = false
func _ready() -> void:
	change_text()
	phone_panel.visible = false
	$Phone/Navigation/Close_Apps.pressed.connect(change_app.bind(main_app, true))
	$Phone/Main/Tutorial_App.pressed.connect(change_app.bind(tutorial_app))
	$Phone/Main/Map_App.pressed.connect(change_app.bind(map_app))
	$Phone/Main/Work_App.pressed.connect(change_app.bind(work_app))
	$Phone/Main/Notes_App.pressed.connect(change_app.bind(notes_app))
	$Phone/Main/Sms_App.pressed.connect(change_app.bind(sms_app))
	$Phone/Main/Settings_App.pressed.connect(change_app.bind(settings_app))
	
func phone():
	_phone = !_phone
	tutorial_app.visible = false
	map_app.visible = false
	work_app.visible = false
	notes_app.visible = false
	sms_app.visible = false
	settings_app.visible = false
	main_app.visible = true
	current_app = main_app
	if _phone:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	phone_panel.visible = _phone
func change_app(app: Panel, close := false):
	if close and current_app == main_app:
		phone()
		return
	if app is Panel:
		current_app.visible = false
		app.visible = true
		current_app = app

#region Settings
func change_text():
	music_level.text = str(music_volum)
	sfx_level.text = str(sfx_volum)
func _on_music_plus_pressed() -> void:
	music_volum += 0.1
	if music_volum <= 1:
		AudioServer.set_bus_volume_db(bus_music, false)
		AudioServer.set_bus_volume_db(bus_music, linear_to_db(music_volum))
	else:
		music_volum = 1
		AudioServer.set_bus_volume_db(bus_music, false)
		AudioServer.set_bus_volume_db(bus_music, linear_to_db(music_volum))
	change_text()
func _on_music_minus_pressed() -> void:
	music_volum -= 0.1
	if music_volum > 0:
		AudioServer.set_bus_volume_db(bus_music, false)
		AudioServer.set_bus_volume_db(bus_music, linear_to_db(music_volum))
	else:
		music_volum = 0
		AudioServer.set_bus_volume_db(bus_music, true)
	change_text()
func _on_sfx_plus_pressed() -> void:
	sfx_volum += 0.1
	if sfx_volum > 1:
		sfx_volum = 1
	AudioServer.set_bus_volume_db(bus_sfx, false)
	AudioServer.set_bus_volume_db(bus_sfx, linear_to_db(sfx_volum))
	change_text()
func _on_sfx_minus_pressed() -> void:
	sfx_volum -= 0.1
	if sfx_volum > 0:
		AudioServer.set_bus_volume_db(bus_sfx, false)
		AudioServer.set_bus_volume_db(bus_sfx, linear_to_db(sfx_volum))
	else:
		sfx_volum = 0
		AudioServer.set_bus_volume_db(bus_sfx, true)
	change_text()
func _on_fs_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
func _on_extra_ui_toggled(toggled_on: bool) -> void:
	extra_ui.visible = toggled_on
#endregion
