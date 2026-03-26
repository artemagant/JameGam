extends SpringArm3D

@export var car_node: Node3D        # Перетащи узел машины сюда в инспекторе
@export var MouseSensitivity = 0.1
@export var IdleTime = 3.0         # Через сколько секунд возвращать камеру
@export var ReturnSpeed = 3.0      # Скорость "доводки" камеры

var idle_timer = 0.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	set_as_top_level(true)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		idle_timer = 0.0
		
		rotation_degrees.x -= event.relative.y * MouseSensitivity
		rotation_degrees.x = clamp(rotation_degrees.x, -90.0, 0.0)
		
		rotation_degrees.y -= event.relative.x * MouseSensitivity
		rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)

func _process(delta: float) -> void:
	if car_node:
		global_position = car_node.global_position
		
		idle_timer += delta
		
		if idle_timer >= IdleTime:

			var target_rad_y = car_node.global_transform.basis.get_euler().y - PI if car_node.game.gear != 0 else car_node.global_transform.basis.get_euler().y
			var current_rad_y = deg_to_rad(rotation_degrees.y)

			rotation_degrees.y = rad_to_deg(lerp_angle(current_rad_y, target_rad_y, ReturnSpeed * delta * 0.20))

			rotation_degrees.x = lerp(rotation_degrees.x, -20.0, ReturnSpeed * delta)
