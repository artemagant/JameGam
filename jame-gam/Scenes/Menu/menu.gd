extends Node2D

signal quit
signal settings
signal start

func _on_quit_pressed() -> void:
	quit.emit()


func _on_settings_pressed() -> void:
	settings.emit()


func _on_start_pressed() -> void:
	start.emit()
