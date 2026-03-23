extends SpringArm3D

var MouseSensitivity = 0.1

@onready var main: = get_parent().get_parent()

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	set_as_top_level(true)
	print(main)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.x -= event.relative.y * MouseSensitivity
		rotation_degrees.x = clamp(rotation_degrees.x, -90.0, -10.0)
		
		rotation_degrees.y -= event.relative.x * MouseSensitivity
		rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)
