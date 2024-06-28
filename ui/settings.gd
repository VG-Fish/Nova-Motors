extends Control


var custom_theme: Theme = load("res://ui/ui.tres")
var fonts: Array[FontFile] = [
	load("res://Assets/font/dogica.ttf"), 
	load("res://Assets/font/dogicabold.ttf"),
	load("res://Assets/font/dogicapixel.ttf"),
	load("res://Assets/font/dogicapixelbold.ttf")
]
var muted: bool = false


func _on_mute_pressed():
	muted = !muted
	for i in range(AudioServer.bus_count):
		AudioServer.set_bus_mute(i, muted)


func _on_sfx_value_changed(value):
	AudioServer.set_bus_volume_db(2, linear_to_db(value))
	AudioServer.set_bus_mute(2, value <= 0.5)


func _on_sound_value_changed(value):
	AudioServer.set_bus_volume_db(1, linear_to_db(value))
	AudioServer.set_bus_mute(1, value <= 0.5)


func _on_option_button_item_selected(index):
	custom_theme.default_font = fonts[index]


func _on_spin_box_value_changed(value):
	custom_theme.default_font_size = value


func _on_main_menu_button_pressed():
	visible = false
