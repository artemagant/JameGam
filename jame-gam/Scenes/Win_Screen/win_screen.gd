extends Node2D
@onready var main: Node2D = $".."

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
func _on_restart_pressed() -> void:
	main.restart()
