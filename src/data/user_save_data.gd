extends Node

const SAVE_FILE = "user://save.json"

var stocks = Stocks.new()
var last_served_orders = []
var current_cash = 0.0
var current_day = 0
var _save_time = 0

func save_data() -> void:
	_save_time = OS.get_unix_time()

	var file = File.new()
	var err = file.open(SAVE_FILE, File.WRITE)
	ErrorHandler.handle(err)
	file.store_string(to_json(_get_data()))
	file.close()


func load_data() -> void:
	var file := File.new()

	if not file.file_exists(SAVE_FILE):
		save_data()
		return

	var open_err = file.open(SAVE_FILE, File.READ)
	ErrorHandler.handle(open_err)

	var data := JSON.parse(file.get_as_text())
	
	if data.error != OK:
		ErrorHandler.handle(data.error)
		save_data()
		return

	_set_from_data(data.result)


func _get_data() -> Dictionary:
	return {
		"_save_time" : _save_time,
		"current_cash" : current_cash,
		"current_day" : current_day,
		"stocks" : stocks._data
	}


func _set_from_data(data: Dictionary) -> void:
	_save_time = _get_or_default(data, "_save_time", 0)
	current_cash = _get_or_default(data, "current_cash", 0.0)
	current_day = _get_or_default(data, "current_day", 0)
	var stocks_data = _get_or_default(data, "stocks", {})
	for key in stocks_data.keys():
		stocks._data[int(key)] = stocks_data[key]


func _get_or_default(data: Dictionary, key: String, default) -> Object:
	if data.has(key):
		return data[key]
	return default
