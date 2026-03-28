extends CanvasGroup

@onready var new_sms_pop_up: Panel = $New_SMS_PopUp

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

var ones_shifts_apps := {
	"Tutorial_App": 1,
	"Map_App": 1,
	"Work_App": 1,
	"Notes_App": 1,
	"Sms_App": 1,
	"Settings_App": 1,
}
# Settings
@onready var music_level: Label = $Phone/Settings_App/Buttons/HBoxContainer/Control/CenterContainer/Music_Level
@onready var sfx_level: Label = $Phone/Settings_App/Buttons/HBoxContainer2/Control/CenterContainer/SFX_Level
@onready var extra_ui: Control = $Extra_UI
var music_volum := 0.5
var sfx_volum := 0.5
var bus_music: = AudioServer.get_bus_index("Music")
var bus_sfx: = AudioServer.get_bus_index("SFX")

var _phone: = false
# Sms
@onready var smses := $Phone/Sms_App/Smses.get_children()
func _ready() -> void:
	Data.load_data()
	$Phone/Settings_App/Buttons/Control2/Extra_UI.button_pressed = Data.data["extra_ui"]
	$Phone/Settings_App/Buttons/Control/FS.button_pressed = Data.data["fs"]
	extra_ui.visible = Data.data["extra_ui"]
	if Data.data["fs"]:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	music_volum = Data.data["music_volum"]
	sfx_volum = Data.data["sfx_volum"]
	if music_volum <= 1:
		AudioServer.set_bus_volume_db(bus_music, false)
		AudioServer.set_bus_volume_db(bus_music, linear_to_db(music_volum))
	else:
		music_volum = 1
		AudioServer.set_bus_volume_db(bus_music, false)
		AudioServer.set_bus_volume_db(bus_music, linear_to_db(music_volum))
	if sfx_volum > 1:
		sfx_volum = 1
	AudioServer.set_bus_volume_db(bus_sfx, false)
	AudioServer.set_bus_volume_db(bus_sfx, linear_to_db(sfx_volum))
	change_text()
	send_new_sms(false)
	change_text()
	notification_popup()
	phone_panel.visible = false
	$Phone/Navigation/Close_Apps.pressed.connect(change_app.bind(main_app, true))
	$Phone/Main/Tutorial_App.pressed.connect(change_app.bind(tutorial_app))
	$Phone/Main/Map_App.pressed.connect(change_app.bind(map_app))
	$Phone/Main/Work_App.pressed.connect(change_app.bind(work_app))
	$Phone/Main/Notes_App.pressed.connect(change_app.bind(notes_app))
	$Phone/Main/Sms_App.pressed.connect(change_app.bind(sms_app))
	$Phone/Main/Settings_App.pressed.connect(change_app.bind(settings_app))

func notification_popup():
	if _phone:
		return
	new_sms_pop_up.visible = true

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
		if app.name != "Main":
			one_shift_notification(app.name, false)
			var values = ones_shifts_apps.values()
			if values == [0, 0, 0, 0, 0, 0]:
				new_sms_pop_up.visible = false
			else:
				new_sms_pop_up.visible = true 
func one_shift_notification(_name: String, state: bool):
	main_app.get_node(_name).get_child(0).visible = state
	ones_shifts_apps[_name] = int(state)
	var values = ones_shifts_apps.values()
	if values == [0, 0, 0, 0, 0, 0]:
		new_sms_pop_up.visible = false
#region Settings
func change_text():
	music_level.text = str(music_volum)
	sfx_level.text = str(sfx_volum)
func _on_music_plus_pressed() -> void:
	music_volum += 0.1
	Data.data["music_volum"] = music_volum
	if music_volum <= 1:
		AudioServer.set_bus_volume_db(bus_music, false)
		AudioServer.set_bus_volume_db(bus_music, linear_to_db(music_volum))
	else:
		music_volum = 1
		AudioServer.set_bus_volume_db(bus_music, false)
		AudioServer.set_bus_volume_db(bus_music, linear_to_db(music_volum))
	change_text()
	Data.save()
func _on_music_minus_pressed() -> void:
	music_volum -= 0.1
	Data.data["music_volum"] = music_volum
	if music_volum > 0:
		AudioServer.set_bus_volume_db(bus_music, false)
		AudioServer.set_bus_volume_db(bus_music, linear_to_db(music_volum))
	else:
		music_volum = 0
		AudioServer.set_bus_volume_db(bus_music, true)
	change_text()
	Data.save()
func _on_sfx_plus_pressed() -> void:
	sfx_volum += 0.1
	Data.data["sfx_volum"] = sfx_volum
	if sfx_volum > 1:
		sfx_volum = 1
	AudioServer.set_bus_volume_db(bus_sfx, false)
	AudioServer.set_bus_volume_db(bus_sfx, linear_to_db(sfx_volum))
	change_text()
	Data.save()
func _on_sfx_minus_pressed() -> void:
	sfx_volum -= 0.1
	Data.data["sfx_volum"] = sfx_volum
	if sfx_volum > 0:
		AudioServer.set_bus_volume_db(bus_sfx, false)
		AudioServer.set_bus_volume_db(bus_sfx, linear_to_db(sfx_volum))
	else:
		sfx_volum = 0
		AudioServer.set_bus_volume_db(bus_sfx, true)
	change_text()
	Data.save()
func _on_fs_toggled(toggled_on: bool) -> void:
	Data.data["fs"] = toggled_on
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	Data.save()
func _on_extra_ui_toggled(toggled_on: bool) -> void:
	Data.data["extra_ui"] = toggled_on
	extra_ui.visible = toggled_on
	Data.save()
#endregion
#region SMS
func send_new_sms(increment: bool = false):
	if increment:
		Data.data["sms_level"] += 1
	for i in Data.data["sms_level"]:
		if i < 6:
			smses[i].visible = true
		else:
			i = 5
			break
#endregion
