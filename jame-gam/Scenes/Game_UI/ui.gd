extends CanvasGroup

@onready var game: Node3D = $".."

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
# Work
@onready var balance: Label = $Phone/Work_App/Balance_Panel/CenterContainer/Balance
var working := false
@onready var points: Array = $"../Environment/Points/Points".get_children()
@onready var info_full: Label = $Phone/Work_App/Info_Panel/Info_Full
var point: int
var adresses := ["", "c.Medium School st. 1", "c.Medium Live st. 4", "v.Small Last st. 3", "v.Small Main st. 2", "v.Big Cross st. 1", "v.Big Road st. 8"]
var names := ["", "Jeffry Lum", "Ronald Barr", "Marie Connor", "Kaily Pugh", "Fred Nerk", "Will Forbis"]
var work_level := 0

@export var pages := [
	
]
@onready var texture_rect: TextureRect = $Phone/Tutorial_App/Picture/TextureRect

func _ready() -> void:
	Data.reset()
	if not Data.load_data():
		Data.reset()
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
	if not DisplayServer.is_touchscreen_available():
		$Phone_Buttons.visible = false
	change_page(0)
	add_money(0)
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
	$Phone/Tutorial_App/Panel/Button.pressed.connect(change_page.bind(-1))
	$Phone/Tutorial_App/Panel/Button2.pressed.connect(change_page.bind(1))
	
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
	if current_app.name == _name:
		main_app.get_node(_name).get_child(0).visible = false
		ones_shifts_apps[_name] = 0
		return
	main_app.get_node(_name).get_child(0).visible = state
	ones_shifts_apps[_name] = int(state)
	new_sms_pop_up.visible = true
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
		Data.save()
	for i in Data.data["sms_level"]:
		if i < 5:
			smses[i].visible = true
			one_shift_notification("Sms_App", true)
		else:
			i = 4
			break
#endregion
#region Work
func add_money(value: int = 1):
	Data.data["money"] += value
	balance.text = "Coins: %d" % Data.data["money"]
	if Data.data["Completed"] == [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0] or Data.data["money"] >= 6:
		win()
func start_new_job():
	if working: return
	working = true
	work_level = 0
	point = randi_range(1, points.size() - 1)
	while Data.data["Completed"][point] == 1:
		if Data.data["Completed"] == [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0] or Data.data["money"] >= 6:
			win()
			break
		point = randi_range(1, points.size() - 1)
	for p in points: p.visible = false
	points[0].visible = true 
	info_full.text = "Job: Pickup Paper\nFrom: Company Vasa"

func _on_point_reached(reached_index: int):
	if not working: return
	if work_level == 0 and reached_index == 0:
		work_level = 1
		points[0].visible = false
		points[point].visible = true
		one_shift_notification("Work_App", true)
		info_full.text = "Name: %s\nTo: %s\nDeliver the package!" % [names[point], adresses[point]]

	elif work_level == 1:
		complete_delivery()

func complete_delivery():
	if randf() > 0.25:
		send_new_sms(true)
	add_money(1)
	working = false
	work_level = 0
	Data.data["Completed"][point] = 1
	if Data.data["Completed"] == [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0] or Data.data["money"] >= 6:
		win()
	points[point].visible = false
	one_shift_notification("Work_App", true)
	info_full.text = "Delivery Complete!\nYou get 1 coin\nTake new order!."
	Data.save()
func win():
	game.win()
#endregion
func change_page(amount: = 1):
	Data.data["page"] += amount
	if Data.data["page"] >= pages.size():
		Data.data["page"] = 0
	if Data.data["page"] < 0:
		Data.data["page"] = pages.size() - 1
	texture_rect.texture = pages[Data.data["page"]]
