extends Node2D


@onready var fade: ColorRect = $Fade
@onready var menu: Node2D = $Menu
@onready var settings_menu: Node2D = $Settings_Menu
@export var game = preload("res://Scenes/Game/game.tscn")

@onready var current_state: Node = menu

@onready var past_scene: Node = menu

@onready var engine_timer: Timer
@export var engine_start_wait_time := 2.0
var e_pressed := false
var is_engine_started := false

func _ready() -> void:
	# Connect signals
	menu.connect("quit", quit)
	menu.connect("settings", settings)
	menu.connect("start", start)
	settings_menu.connect("return_to_menu", return_to_menu)
	settings_menu.connect("_return", _return)
	_fade()

func _fade(to_alfa = 0.0, time = 0.5):
	var tween: = get_tree().create_tween()
	tween.tween_property(fade, "modulate:a", to_alfa, time)
	await tween.finished

func change_state(state: Node = menu):
	current_state.visible = false
	current_state = state
	state.visible = true

func quit():
	await _fade(1.0)
	get_tree().quit()

func settings():
	await _fade(1.0)
	change_state(settings_menu)
	await _fade()

func start():
	if game and game is Node3D:
		return
	game = game.instantiate()
	await _fade(1.0)
	current_state.visible = false
	current_state = game
	add_child(game)
	engine_timer = game.get_child(3)
	await _fade()

func return_to_menu():
	await _fade(1.0)
	past_scene = menu
	change_state(menu)
	await _fade()

func _return():
	await _fade(1.0)
	change_state(past_scene)
	await _fade()

func return_to_menu_2():
	await _fade(1.0)
	game.queue_free()
	change_state(menu)
	game = preload("res://Scenes/Game/game.tscn")
	is_engine_started = false
	e_pressed = false
	await _fade()

func _input(event: InputEvent) -> void:
	if game and game is Node3D and game in get_children():
		if event.is_action_pressed("fix"):
			var car = game.get_child(0)
			if car.global_transform.basis.y.dot(Vector3.UP) >= 0.5: 
				return
			car.apply_central_impulse(Vector3(0, 1000, 0))
			car.global_transform.basis = Basis()
		if event.is_action_pressed("exit"):
			game.show_menu()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		if event.is_action_pressed("belt"):
			game.belt = !game.belt
		if event.is_action_pressed("honk"):
			game.honk()
		if event.is_action_pressed("emergency_lights"):
			game.signal_emergency()
		if event.is_action_pressed("turn_left"):
			game.signal_left()
		if event.is_action_pressed("turn_right"):
			game.signal_right()
		if event.is_action_pressed("lights"):
			game.lights_connect()
		if event.is_action_pressed("engine"):
			e_pressed = true
			start_engine()
		if event.is_action_released("engine"):
			e_pressed = false
			engine_timer.stop()
		if event.is_action_pressed("clutch"):
			game.clutch = true
		if event.is_action_released("clutch"):
			game.clutch = not true
		if event.is_action_pressed("add_gear"):
			game.add_gear()
		if event.is_action_pressed("minus_gear"):
			game.minus_gear()
		if event.is_action_pressed("down"):
			game.breake()
		if event.is_action_released("down"):
			game.breake(false)

func start_engine():
	if is_engine_started:
		is_engine_started = false
		e_pressed = false
		game.stop_engine()
		return
	engine_timer.start(engine_start_wait_time)
	await engine_timer.timeout
	if e_pressed:
		game.start_engine()
	e_pressed = false
	is_engine_started = true
