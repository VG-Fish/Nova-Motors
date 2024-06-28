extends Control


@onready var input_button_scene: PackedScene = preload("res://ui/Input Settings/input_button.tscn")
@onready var action_list: VBoxContainer = $"MarginContainer/VBoxContainer/ScrollContainer/Action List"

var is_remapping: bool = false
var action_to_remap: String = ""
var remapping_button: Button = null

var input_actions: Dictionary = {
	"right": "Right Movement",
	"left": "Left Movement",
	"primary action": "Primary Interact",
}


func _ready() -> void:
	Globals.load_config_file("res://saves/user_input_map.cfg", "God")
	create_action_list()
	

func create_action_list() -> void:
	# To make sure nothing exists
	for actn in action_list.get_children():
		actn.queue_free()
		
	for actn in input_actions:
		var input_button: Button = input_button_scene.instantiate()
		var action_label: Label = input_button.find_child("Action")
		var input_label: Label = input_button.find_child("Input")
		
		action_label.text = input_actions[actn]

		var events: Array[InputEvent] = InputMap.action_get_events(actn)
		# Ensure event exists
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""
		
		action_list.add_child(input_button)
		
		# This allows player to change inputs
		input_button.pressed.connect(on_input_button_pressed.bind(input_button, action))


func on_input_button_pressed(button: Button, actn: String) -> void:
	if !is_remapping:
		is_remapping = true
		remapping_button = button
		action_to_remap = actn
		button.find_child("Input").text = "Press any key to bind..."


func _input(event: InputEvent) -> void:
	if is_remapping:
		if (
			event is InputEventKey or 
			(event is InputEventMouseButton and event.pressed)
		):
			# No double clicking
			if event is InputEventMouseButton and event.double_click:
				event.double_click = false

			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			update_action_list(remapping_button, event)
			Globals.save_keybinding(action_to_remap, event)
			
			is_remapping = false
			action_to_remap = ""
			remapping_button = null

			# This marks an event as handled and stop the event from 
			# propogating up the tree.
			accept_event()


func update_action_list(button: Button, event: InputEvent) -> void:
	button.find_child("Input").text = event.as_text().trim_suffix(" (Physical)")


func _on_reset_button_pressed():
	Globals.load_default_input_map_settings()
	create_action_list()
