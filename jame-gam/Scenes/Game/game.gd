extends Node3D

@onready var ui := $UI
@onready var ui_stats := ui.get_child(2).get_child(0)
@onready var stats_text = ui_stats.text

@onready var car = get_child(0)

var speed: float
@onready var _position = car.position
@onready var previous_position = _position
var max_speed: float

func _ready() -> void:
	update_ui_stats()
	change_speed()

func _process(_delta: float) -> void:
	if _position != car.position:
		_position = car.position
		update_ui_stats()

func update_ui_stats() -> void:
	ui_stats.text = "Info:
		Speed - %.2f mps
		Coordinates - (%.1f, %.1f, %.1f)
		Max Speed - %.2f mps
		..." %[speed, _position.x, _position.y, _position.z, max_speed]

func change_speed() -> void:
	var dist = _position.distance_to(previous_position)
	speed = dist / 0.1
	if speed > max_speed:
		max_speed = speed
	previous_position = _position
	update_ui_stats()
	await get_tree().create_timer(0.1).timeout
	change_speed()
