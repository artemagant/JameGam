extends Node2D

@onready var fade: ColorRect = $Fade
@onready var menu: Node2D = $Menu
@onready var settings_menu: Node2D = $Settings_Menu
@onready var game: Node2D = $Game

@onready var current_state: Node2D = menu

func _ready() -> void:
	# Connect signals
	menu.connect("quit", quit)
	menu.connect("settings", settings)
	menu.connect("start", start)
	_fade()

func _fade(to_alfa = 0, time = 1):
	var tween: = get_tree().create_tween()
	tween.tween_property(fade, "modulate:a", to_alfa, time)
	await tween.finished

func change_state(state: Node2D = menu):
	current_state.visible = false
	current_state = state
	state.visible = true

func quit():
	get_tree().quit()

func settings():
	change_state(settings_menu)

func start():
	change_state(game)
