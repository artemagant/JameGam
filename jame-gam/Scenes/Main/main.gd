extends Node2D


@onready var fade: ColorRect = $Fade
@onready var menu: Node2D = $Menu
@onready var settings_menu: Node2D = $Settings_Menu
@export var game = preload("res://Scenes/Game/game.tscn")

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
	if game and game is Node3D:
		return
	game = game.instantiate()
	await _fade(1.0)
	current_state.visible = false
	current_state = game
	add_child(game)
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

func return_to_menu_2():
	await _fade(1.0)
	game.queue_free()
	change_state(menu)
	game = preload("res://Scenes/Game/game.tscn")
	await _fade()
	

func _input(event: InputEvent) -> void:
	if game and game is Node3D and game in get_children():
		if event.is_action_pressed("fix"):
			var car = game.get_child(0)
			if not car.global_transform.basis.y.dot(Vector3.UP) >= 0.5: 
				return
			car.apply_central_impulse(Vector3(0, 10000, 0))
			car.global_transform.basis = Basis()
		if event.is_action_pressed("exit"):
			game.show_menu()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
