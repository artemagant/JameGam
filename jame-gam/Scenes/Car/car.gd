extends VehicleBody3D

# Script for car

# Max Rotations Per Minute
@export var max_RPM: float
# Max aceleration
@export var max_torque: float
# Turn speed ( lower - slower )
@export var turn_speed: float
# hz
@export var turn_amount: = 0.05

# Arrays, that describe values of car's characteristics
@onready var  max_RPM_gears := [200, 2000, 200, 300, 500, 800, 1200, 1500]
@onready var max_torque_gears := [150, 1, 150, 200, 400, 600, 700, 1200]
@onready var turn_speed_gears := [3.0, 4.0, 4.0, 3.0, 2.0, 1.5, 1.0, 0.4]
@onready var min_RPM_gears := [0, 0, 0, 50, 100, 150, 200, 400]

# From scene
@onready var cam_arm: SpringArm3D = $CamArm
@onready var wheel_back_left: VehicleWheel3D = $wheel_back_left
@onready var wheel_back_right: VehicleWheel3D = $wheel_back_right
@onready var wheel_front_left: VehicleWheel3D = $wheel_front_left
@onready var wheel_front_right: VehicleWheel3D = $wheel_front_right
@onready var game: Node3D = $".."
@onready var lights_1: Node3D = $body/Lights_1
@onready var lights_2: Node3D = $body/Lights_2
@onready var signal_left: MeshInstance3D = $body/Signal_Left
@onready var signal_right: MeshInstance3D = $body/Signal_Right
@onready var signals_timer: Timer = $Signals_Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Brake
var breake: = false
# Power of brake
@export var brake_amount: = 5.0

# Current RPM
@onready var RPM: float
# RPM, that loosing after new gear
var minus_rpm: float
# Minus everything if clutch is holding
var clutch_mult: = 1.0
func _process(_delta: float) -> void:
	if game.turn_signals == Vector2(0, 0):
		signal_right.visible = false
		signal_left.visible = false
		animation_player.stop()
	if game.turn_signals == Vector2(1, 0):
		animation_player.play("left_blink")
		signal_right.visible = false
		signal_left.visible = true
	if game.turn_signals == Vector2(0, 1):
		animation_player.play("right_blink")
		signal_right.visible = true
		signal_left.visible = false
	if game.turn_signals == Vector2(1, 1):
		animation_player.play("emerjency_signal")
		signal_left.visible = true
		signal_right.visible = true

func _physics_process(delta: float) -> void:
	# check if clutch
	if game.clutch:
		clutch_mult = 0.5
	else:
		clutch_mult = 1.0
	# check if minus rpm
	if minus_rpm > 0:
		minus_rpm -= 0.1
	else:
		minus_rpm = 0
	# Adgast camera 
	cam_arm.position = position
	# direction of drive ( left of right )
	var steering_dir = Input.get_action_strength("left") - Input.get_action_strength("right")
	# Turn of wheels
	steering = lerp(steering, steering_dir * turn_amount, turn_speed * delta)
	# Direction of drive ( forward or backwards)
	var dir = Input.get_action_strength("up") if game.gear > 0 else -Input.get_action_strength("up")
	# rpm of single wheel
	var RPM_left = abs(wheel_back_left.get_rpm())
	var RPM_right = abs(wheel_back_right.get_rpm())
	# total rpm
	RPM = (RPM_left + RPM_right) / 2.0
	if minus_rpm > RPM:
		RPM = 0
	else:
		RPM -= minus_rpm
	
	# Power of engine
	var torque = dir * max_torque * (1.0 - RPM / max_RPM)
	# Check if engine is on and apply changes
	if game.engine and not game.handbrake:
		engine_force = torque * clutch_mult
		brake = 2 if dir == 0 else 0
	else:
		engine_force = 0
		brake = 2
	# Brake
	if breake:
		brake += brake_amount

func add_gear(): # Add gear
	# Check if rpm is alright
	if RPM < min_RPM_gears[game.gear] - 10:
		game.minus_gear()
		return
	# Minus then new
	minus_rpm += game.gear
	# Update stats
	max_RPM = max_RPM_gears[game.gear]
	max_torque = max_torque_gears[game.gear]
	turn_speed = turn_speed_gears[game.gear]
func minus_gear(): # Like add gear, but without checking the rpm
	minus_rpm += game.gear
	max_RPM = max_RPM_gears[game.gear]
	max_torque = max_torque_gears[game.gear]
	turn_speed = turn_speed_gears[game.gear]

func turn_lights():
	if game.lights == 0:
		lights_1.visible = false
		lights_2.visible = false
	if game.lights == 1:
		lights_1.visible = true
		lights_2.visible = false
	if game.lights == 2:
		lights_1.visible = false
		lights_2.visible = true
