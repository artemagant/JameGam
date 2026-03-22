extends Node2D

@onready var fade: ColorRect = $Fade

func _ready() -> void:
	_fade()

func _fade(to_alfa = 0, time = 1):
	var tween: = get_tree().create_tween()
	tween.tween_property(fade, "modulate:a", to_alfa, time)
	await tween.finished
