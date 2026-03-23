extends VehicleBody3D

@export var max_RPM = 450
@export var max_torque = 300
@export var turn_speed = 6
@export var turn_amount = 0.05
@onready var cam_arm: SpringArm3D = $CamArm
@onready var wheel_back_left: VehicleWheel3D = $wheel_back_left
@onready var wheel_back_right: VehicleWheel3D = $wheel_back_right
@onready var wheel_front_left: VehicleWheel3D = $wheel_front_left
@onready var wheel_front_right: VehicleWheel3D = $wheel_front_right

func _physics_process(delta: float) -> void:
	cam_arm.position = position
	
	var dir = Input.get_action_strength("up") - Input.get_action_strength("down")
	var steering_dir = Input.get_action_strength("left") - Input.get_action_strength("right")
	
	var RPM_left = abs(wheel_back_left.get_rpm())
	var RPM_right = abs(wheel_back_right.get_rpm())
	var RPM = (RPM_left + RPM_right) / 2.0
	
	var torque = dir * max_torque * (1.0 - RPM / max_RPM)
	
	engine_force = torque
	steering = lerp(steering, steering_dir * turn_amount, turn_speed * delta)
	
	if dir == 0:
		brake = 2
	
