extends Node3D

@onready var ui := $UI
@onready var ui_stats := ui.get_child(1).get_child(0)
@onready var menu_game: Node2D = $Menu_Game
@onready var main: = get_parent()

@onready var car = get_child(0)

var speed: float
@onready var _position = car.position
var max_speed: float
var belt: bool = false
var turn_signals: = Vector2.ZERO
var lights: int = 0
var engine: = false

func _ready() -> void:
	update_ui_stats()

func _process(_delta: float) -> void:
	var current_velocity = car.linear_velocity.length() 
	speed = current_velocity
	if speed > max_speed:
		max_speed = speed


func update_ui_stats() -> void:
	_position = car.position
	ui_stats.text = "Info: Car Real
		Engine - %d
		Speed - %.2f mps
		Coordinates - (%.1f, %.1f, %.1f)
		Max Speed - %.2f mps
		Belt - %d
		Signals - (%d, %d)
		Lights - %d
		..." %[int(engine), speed, _position.x, _position.y, _position.z, max_speed, int(belt), turn_signals.x, turn_signals.y, lights]

func show_menu():
	if menu_game.visible:
		menu_game.visible = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		menu_game.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func return_to_menu():
	ui.visible = false
	main.return_to_menu_2()

func honk():
	print("honk")

func signal_left():
	if turn_signals == Vector2(1, 1):
		return
	if turn_signals == Vector2(1, 0):
		turn_signals = Vector2.ZERO
		return
	turn_signals = Vector2(1, 0)
func signal_right():
	if turn_signals == Vector2(1, 1):
		return
	if turn_signals == Vector2(0, 1):
		turn_signals = Vector2.ZERO
		return
	turn_signals = Vector2(0, 1)
func signal_emergency():
	if turn_signals == Vector2(1, 1):
		turn_signals = Vector2.ZERO
		return
	turn_signals = Vector2(1,1)

func lights_connect():
	if lights == 2:
		lights = 0
		return
	lights += 1

func start_engine():
	engine = true
func stop_engine():
	engine = false


func _on_ui_update_timer_timeout() -> void:
	update_ui_stats()
