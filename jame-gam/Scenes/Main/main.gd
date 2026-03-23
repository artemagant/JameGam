extends Node2D

@onready var fade: ColorRect = $Fade
@onready var menu: Node2D = $Menu
@onready var settings_menu: Node2D = $Settings_Menu
@onready var game: Node3D = $Game

@onready var current_state: Node = menu

@onready var past_scene: Node = menu

func _ready() -> void:
	# Connect signals
	menu.connect("quit", quit)
	menu.connect("settings", settings)
	menu.connect("start", start)
	settings_menu.connect("return_to_menu", return_to_menu)
	settings_menu.connect("_return", _return)
	_fade()

func _fade(to_alfa = 0.0, time = 0.5):
	var tween: = get_tree().create_tween()
	tween.tween_property(fade, "modulate:a", to_alfa, time)
	await tween.finished

func change_state(state: Node = menu):
	current_state.visible = false
	current_state = state
	state.visible = true

func quit():
	await _fade(1.0)
	get_tree().quit()

func settings():
	await _fade(1.0)
	change_state(settings_menu)
	await _fade()

func start():
	await _fade(1.0)
	past_scene = game
	change_state(game)
	await _fade()

func return_to_menu():
	await _fade(1.0)
	past_scene = menu
	change_state(menu)
	await _fade()

func _return():
	await _fade(1.0)
	change_state(past_scene)
	await _fade()
