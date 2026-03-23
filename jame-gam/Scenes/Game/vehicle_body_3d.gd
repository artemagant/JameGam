extends VehicleBody3D

@export var max_steer = 0.9
@export var engine_power = 300

func _physics_process(delta: float) -> void:
	steering = move_toward(steering, Input.get_axis("right", "left") * max_steer, delta * 10)
	engine_force = Input.get_axis("down", "up") * engine_power
