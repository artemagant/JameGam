extends Node2D

@onready var game = get_parent()

func _on_return_pressed() -> void:
	game.show_menu()


func _on_return_to_menu_pressed() -> void:
	game.return_to_menu()
