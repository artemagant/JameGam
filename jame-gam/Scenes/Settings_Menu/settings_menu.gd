extends Node2D

signal return_to_menu
signal _return

func _ready() -> void:
	change_text()

func _on_fs_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

var bus_music: = AudioServer.get_bus_index("Music")
var bus_sfx: = AudioServer.get_bus_index("SFX")

var music_volum := 0.5
var sfx_volum := 0.5
@onready var music_level: Label = $Buttons/HBoxContainer/CenterContainer/Music_Level
@onready var sfx_level: Label = $Buttons/HBoxContainer2/CenterContainer/SFX_Level

func _on_music_plus_pressed() -> void:
	music_volum += 0.1
	if music_volum <= 1:
		AudioServer.set_bus_volume_db(bus_music, false)
		AudioServer.set_bus_volume_db(bus_music, linear_to_db(music_volum))
	else:
		music_volum = 1
		AudioServer.set_bus_volume_db(bus_music, false)
		AudioServer.set_bus_volume_db(bus_music, linear_to_db(music_volum))
	change_text()
func _on_music_minus_pressed() -> void:
	music_volum -= 0.1
	if music_volum > 0:
		AudioServer.set_bus_volume_db(bus_music, false)
		AudioServer.set_bus_volume_db(bus_music, linear_to_db(music_volum))
	else:
		music_volum = 0
		AudioServer.set_bus_volume_db(bus_music, true)
	change_text()


func _on_sfx_plus_pressed() -> void:
	sfx_volum += 0.1
	if sfx_volum > 1:
		sfx_volum = 1
	AudioServer.set_bus_volume_db(bus_sfx, false)
	AudioServer.set_bus_volume_db(bus_sfx, linear_to_db(sfx_volum))
	change_text()
func _on_sfx_minus_pressed() -> void:
	sfx_volum -= 0.1
	if sfx_volum > 0:
		AudioServer.set_bus_volume_db(bus_sfx, false)
		AudioServer.set_bus_volume_db(bus_sfx, linear_to_db(sfx_volum))
	else:
		sfx_volum = 0
		AudioServer.set_bus_volume_db(bus_sfx, true)
	change_text()


func change_text():
	music_level.text = str(music_volum)
	sfx_level.text = str(sfx_volum)


func _on_return_to_menu_pressed() -> void:
	return_to_menu.emit()


func _on_return_pressed() -> void:
	_return.emit()
