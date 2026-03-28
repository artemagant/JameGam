extends Node3D

# From scene
@onready var ui := $UI
@onready var ui_stats := ui.get_child(1).get_child(0)
@onready var menu_game: Node2D = $Menu_Game
@onready var main: = get_parent()
@onready var car = get_child(0)

var speed: float # speed of car
@onready var _position = car.position # current position of car
var max_speed: float # max speed that car reached
var belt: bool = false # if belt on
var turn_signals: = Vector2.ZERO # turn zignals
var lights: int = 0 # none, light and mege
var engine: = false # if engine on
var clutch: = false # if clutch did
var gear: = 1 # current gear

var handbrake: = true

func _ready() -> void:
	update_ui_stats() # update ui
	car.add_gear() # update car stats

func _process(_delta: float) -> void:
	# check speed and update max speed
	var current_velocity = car.linear_velocity.length() 
	speed = current_velocity -0.01
	if speed > max_speed:
		max_speed = speed
	if gear > 1 and speed < 0.05 and not clutch: # if speed is 0, engine is off
		await get_tree().create_timer(0.7).timeout
		if gear > 1 and speed < 0.05 and not clutch:
			engine = false
			main.is_engine_started = false


func update_ui_stats() -> void:
	_position = car.position # update position
	# update text
	ui_stats.text = "Info: Car Real
		Engine - %d
		Speed - %.2f mps
		Clutch - %d
		Gear - %d
		Coordinates - (%.1f, %.1f, %.1f)
		Max Speed - %.2f mps
		Belt - %d
		Signals - (%d, %d)
		Lights - %d
		RPM - %.2f
		Handbrake - %d
		..." %[int(engine), abs(speed), int(clutch), gear-1, _position.x, _position.y, _position.z, max_speed, int(belt), turn_signals.x, turn_signals.y, lights, car.RPM, int(handbrake)]

func show_menu(): # shows game menu
	if menu_game.visible:
		menu_game.visible = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		menu_game.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func return_to_menu(): # Close 3d
	ui.visible = false
	main.return_to_menu_2()

func honk(): # honk
	print("honk")

func signal_left(): # signal left
	if turn_signals == Vector2(1, 1):
		return
	if turn_signals == Vector2(1, 0):
		turn_signals = Vector2.ZERO
		return
	turn_signals = Vector2(1, 0)
func signal_right(): # signal right
	if turn_signals == Vector2(1, 1):
		return
	if turn_signals == Vector2(0, 1):
		turn_signals = Vector2.ZERO
		return
	turn_signals = Vector2(0, 1)
func signal_emergency(): # both signals
	if turn_signals == Vector2(1, 1):
		turn_signals = Vector2.ZERO
		return
	turn_signals = Vector2(1,1)

func lights_connect(): # lights
	if lights == 2:
		lights = 0
		car.turn_lights()
		return
	lights += 1
	car.turn_lights()

func start_engine(): # start engine
	engine = true
func stop_engine(): # off engine
	engine = false

func _on_ui_update_timer_timeout() -> void: # update ui on timer
	update_ui_stats()

func add_gear(): # add gear
	if clutch and gear < 7:
		gear += 1
		car.add_gear()
func minus_gear(): # minus gear
	if clutch and gear > 0:
		gear -= 1
		car.minus_gear()

func breake(iss: bool = true): # brake
	car.breake = iss

func phone():
	ui.phone()
