extends Control
class_name action_layout

var number_of_actions: int = Globals.action_type.regular
var action_scene: PackedScene = preload("res://actions/Base/action.tscn")
var close_action_scene: PackedScene = preload("res://actions/Base/close.tscn")
var previous_actions_text: Array[Dictionary] = []
var action_type: String
var actions: Array[VBoxContainer] = []
@onready var options: VBoxContainer = $Background/VBoxContainer/Options
signal action_done
var use_special_action: bool = true
var interactable_specific_actions: Array = str_to_var(FileAccess.open("res://actions/machine_actions_text.txt", FileAccess.READ).get_as_text())
var machine_action_text: String

func _ready() -> void:
	if number_of_actions == 4:
		action_type = "Regular"
	else:
		action_type = "Board"
	make_actions()

func make_actions() -> void:
	var pot_action: VBoxContainer
	for i in range(number_of_actions):
		if i < 3:
			pot_action = action_scene.instantiate()
			var random_action: Dictionary = get_action()
			if i == 2 and use_special_action:
				var interactable_type: String = get_parent().get_parent().name.rstrip("23456789")
				match interactable_type:
					"Letter Box":
						random_action = interactable_specific_actions[randi_range(8, len(interactable_specific_actions) - 1)]
					"Machine":
						random_action = interactable_specific_actions[randi_range(0, 2)]
					"Employee":
						random_action = interactable_specific_actions[randi_range(3, 7)]
			while (
				previous_actions_text.find(random_action) == -1 and
				random_action["Mode(s)"].get(Globals.mode, false) and
				random_action.Type != action_type and not
				use_special_action
			):
				previous_actions_text.append(random_action)
				random_action = get_action()
			pot_action.find_child("Text").text = random_action.Text
			pot_action.impacted_stats = random_action.Stats
		else:
			pot_action = close_action_scene.instantiate()
			pot_action.find_child("Text").text = "Close Actions? You can view this later."
		pot_action.connect("close", close)
		actions.append(pot_action)
		options.add_child(pot_action)

func close(type: String) -> void:
	if name == "Employee Actions":
		self.not_added = true
	if type == "close":
		visible = false
	else:
		action_done.emit()
		close_actions()

func close_actions() -> void:
	actions = []
	previous_actions_text = []
	for close_action in options.get_children():
		options.remove_child(close_action)
		close_action.queue_free()
	visible = false
	
	if action_type == "Board":
		SceneSwitcher.show_scene(SceneSwitcher.SCENE.OFFICE)
	
	make_actions()

func get_action() -> Dictionary:
	return Globals.customer_review_texts[randi_range(0,  Globals.customer_review_texts.size() - 1)]

func get_action_size() -> Vector2:
	return get_child(0).size
