extends VehicleBody3D

@export var max_RPM: = 2000
@export var max_torque: = 1000
@export var turn_speed: = 0.4
@export var turn_amount: = 0.05

@onready var  max_RPM_gears := [150, 2000, 500, 600, 800, 1000, 1500, 2000]
@onready var max_torque_gears := [100, 1, 350, 400, 500, 600, 800, 1000]
@onready var turn_speed_gears := [3.0, 4.0, 4.0, 3.0, 2.0, 1.5, 1.0, 0.4]
@onready var min_RPM_gears := [0, 0, 0, 50, 100, 150, 200, 400]

@onready var cam_arm: SpringArm3D = $CamArm
@onready var wheel_back_left: VehicleWheel3D = $wheel_back_left
@onready var wheel_back_right: VehicleWheel3D = $wheel_back_right
@onready var wheel_front_left: VehicleWheel3D = $wheel_front_left
@onready var wheel_front_right: VehicleWheel3D = $wheel_front_right
@onready var game: Node3D = $".."

var breake: = false
@export var brake_amount: = 2.0

@onready var RPM: float
var minus_rpm: float

func _physics_process(delta: float) -> void:
	if minus_rpm > 0:
		minus_rpm -= 0.1
	else:
		minus_rpm = 0
	cam_arm.position = position
	var steering_dir = Input.get_action_strength("left") - Input.get_action_strength("right")
	steering = lerp(steering, steering_dir * turn_amount, turn_speed * delta)
	var dir = Input.get_action_strength("up") if game.gear > 0 else -Input.get_action_strength("up")
	var RPM_left = abs(wheel_back_left.get_rpm())
	var RPM_right = abs(wheel_back_right.get_rpm())
	RPM = (RPM_left + RPM_right) / 2.0
	if minus_rpm > RPM:
		RPM = 0
	else:
		RPM -= minus_rpm
	
	
	var torque = dir * max_torque * (1.0 - RPM / max_RPM)
	if game.engine:
		engine_force = torque
		brake = 2 if dir == 0 else 0
	else:
		engine_force = 0
		brake = 2
	if breake:
		brake += brake_amount

func add_gear():
	if RPM < min_RPM_gears[game.gear] - 10:
		game.minus_gear()
	minus_rpm += game.gear
	brake = 500
	max_RPM = max_RPM_gears[game.gear]
	max_torque = max_torque_gears[game.gear]
	turn_speed = turn_speed_gears[game.gear]
func minus_gear():
	brake = 500
	minus_rpm += game.gear
	max_RPM = max_RPM_gears[game.gear]
	max_torque = max_torque_gears[game.gear]
	turn_speed = turn_speed_gears[game.gear]
