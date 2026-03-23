extends Node2D

@onready var fade: ColorRect = $Fade
@onready var menu: Node2D = $Menu
@onready var settings_menu: Node2D = $Settings_Menu
@export var game: = preload("res://Scenes/Game/game.tscn").instantiate()

@onready var current_state: Node2D = menu

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
	current_state.visible = false
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

func _input(event: InputEvent) -> void:
	if game in get_children():
		var car = game.get_child(0)
		if car is VehicleBody3D and event.is_action_pressed("fix"):
	# 1. Подбрасываем (импульс)
			car.apply_central_impulse(Vector3.UP * 10.0) 
	
	# 2. Обнуляем вращение по X и Z, сохраняя направление (Y)
			var current_y_rotation = car.global_rotation.y
			car.global_rotation = Vector3(0, current_y_rotation, 0)
	
	# 3. КРИТИЧНО: Сбрасываем угловую скорость
	# Без этого машина продолжит вращаться в воздухе по инерции
			car.angular_velocity = Vector3.ZERO
	
	# 4. Сбрасываем линейную скорость (опционально)
	# Если хотите, чтобы она просто "зависла" и упала ровно
			car.linear_velocity.x = 0
			car.linear_velocity.z = 0
