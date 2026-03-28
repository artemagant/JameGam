extends Node

const DEFAULT_DATA = {
	"music_volum": 0.5,
	"sfx_volum": 0.5,
	"sms_level": 2,
	"work_level": 1,
	"money": 0,
	"fs": true,
	"extra_ui": true
}

var data := DEFAULT_DATA.duplicate(true)

func reset():
	data = DEFAULT_DATA
	save()

var path = "user://savegame.save"
func save():
	var save_file = FileAccess.open(path, FileAccess.WRITE)
	if save_file == null:
		push_error("Failed to open save file for writing")
		return
	save_file.store_line(JSON.stringify({"data": data}))
	save_file.close()

func load_data():
	if not FileAccess.file_exists(path):
		return false

	var save_file = FileAccess.open(path, FileAccess.READ)
	if save_file == null:
		push_error("Failed to open save file for reading")
		return false  # was missing return value

	var json_string = save_file.get_line()
	save_file.close()

	var json = JSON.new()
	if json.parse(json_string) != OK:
		push_error("Failed to parse save file JSON")
		return false

	var _data = json.get_data()  # fixed from json._data
	data = _data.get("data", DEFAULT_DATA.duplicate(true))
	return true
