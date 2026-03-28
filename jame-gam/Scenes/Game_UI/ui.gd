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

var _phone: = false
func _ready() -> void:
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
