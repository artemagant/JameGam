extends Node2D

# from scene
@onready var fade: ColorRect = $Fade
@onready var menu: Node2D = $Menu
@onready var settings_menu: Node2D = $Settings_Menu
@export var game = preload("res://Scenes/Game/game.tscn")
# current node
@onready var current_state: Node = menu
# past scene
@onready var past_scene: Node = menu
# timer for turn on engine
@onready var engine_timer: Timer
@export var engine_start_wait_time := 2.0 # wait time
var e_pressed := false # e pressed
var is_engine_started := false # is engine sterted

func _ready() -> void:
	# Connect signals
	menu.connect("quit", quit)
	menu.connect("settings", settings)
	menu.connect("start", start)
	settings_menu.connect("return_to_menu", return_to_menu)
	settings_menu.connect("_return", _return)
	_fade()

func _fade(to_alfa = 0.0, time = 0.5): # fade
	var tween: = get_tree().create_tween()
	tween.tween_property(fade, "modulate:a", to_alfa, time)
	await tween.finished

func change_state(state: Node = menu): # change between visibility of current state and new ( settings and menu )
	current_state.visible = false
	current_state = state
	state.visible = true

func quit(): # quit
	await _fade(1.0)
	get_tree().quit()

func settings(): # open settings
	await _fade(1.0)
	change_state(settings_menu)
	await _fade()

func start(): # start 3d fame
	if game and game is Node3D: # check if instantiated
		return
	game = game.instantiate() # instantiate 
	await _fade(1.0)
	current_state.visible = false
	current_state = game
	add_child(game)
	engine_timer = game.get_child(3)
	await _fade()

func return_to_menu(): # return to menu from settings
	await _fade(1.0)
	past_scene = menu
	change_state(menu)
	await _fade()

func _return(): # return to menu from settings
	await _fade(1.0)
	change_state(past_scene)
	await _fade()
var returning = false
func return_to_menu_2(): # return to menu from menu in game
	if returning:
		return
	returning = true
	await _fade(1.0)
	game.queue_free() # close game
	change_state(menu)
	game = preload("res://Scenes/Game/game.tscn")
	is_engine_started = false
	e_pressed = false
	await _fade()
	returning = false

var impuls := false
func _input(event: InputEvent) -> void: # connect every input
	if game and game is Node3D and game in get_children(): # check if in-game
		if event.is_action_pressed("fix"): #r  fix - apply impuls to the car
			if not impuls:
				impuls = true
				var car = game.get_child(0)
				car.apply_central_impulse(Vector3(100, 3000, 100))
				car.global_transform.basis = Basis()
				await get_tree().create_timer(3.0).timeout
				impuls = false
		if event.is_action_pressed("exit"): #esc ESC - opens game menu
			game.show_menu()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		if event.is_action_pressed("belt"): #b belt
			game.belt = !game.belt
		if event.is_action_pressed("honk"): #h honk - honk
			game.honk()
		if event.is_action_pressed("emergency_lights"): #m turn on both signals
			game.signal_emergency()
		if event.is_action_pressed("turn_left"): #,< turn on left signal
			game.signal_left()
		if event.is_action_pressed("turn_right"): #.> turn on right signal
			game.signal_right()
		if event.is_action_pressed("lights"): #l turn on lights
			game.lights_connect()
		if event.is_action_pressed("engine"): #e start engine
			e_pressed = true
			start_engine()
		if event.is_action_released("engine"): #e-r check for pressed
			e_pressed = false
			engine_timer.stop()
		if event.is_action_pressed("clutch"): #t add clutch
			game.clutch = true
		if event.is_action_released("clutch"): #t-r minus clutch
			game.clutch = not true
		if event.is_action_pressed("add_gear"): #w add gear
			game.add_gear()
		if event.is_action_pressed("minus_gear"): #s minus gear
			game.minus_gear()
		if event.is_action_pressed("down"): #arrow down brake
			game.breake()
		if event.is_action_released("down"): #arrow down-r turn off brake
			game.breake(false)
		if event.is_action_pressed("handbrake"):
			if game.handbrake:
				game.handbrake = false
			else:
				game.handbrake = true
		if event.is_action_pressed("phone"):
			game.phone()

func start_engine(): # start engine
	if is_engine_started: # if started, turn it off
		is_engine_started = false
		e_pressed = false
		game.stop_engine()
		return
	engine_timer.start(engine_start_wait_time) # start timer
	await engine_timer.timeout # wait
	if e_pressed: # check if e still pressed
		game.start_engine()
	else:
		e_pressed = false
		return
	e_pressed = false
	is_engine_started = true
