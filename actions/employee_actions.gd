extends action_layout

var dialogue: Control = preload("res://Dialouge/dialoge.tscn").instantiate()
var not_added: bool = true
@onready var employee_info: Label = $Background/VBoxContainer/Text
@onready var background: PanelContainer = $Background
@onready var view_port_size: Vector2 = Vector2(get_viewport().size)
var interactable_name: String
var prompt: String = " ".join([
	"Replace the %20 with spaces in the prompt if there are any.",
	"You are a employee in a game who is presenting a series of actions that the boss (player) can choose.",
	"You change your attitude to your boss depending on the stat employee friendliness, which ranging from 0 to 100.",
	"Please act more cordially with your boss the higher the stat is. Otherwise, present the actions quite arrogantly.",
	"Right now, the stat is: %s." % Globals.stats["employee_friendliness"],
	"In your response, please be very brief and try to respond in less than 20 words and not have redundant spaces."
])
var employee_message: String

func _ready():
	dialogue.label = employee_info
	dialogue.delete = false
	interactable_name = "Joe: "
	
	$HTTPRequest.request_completed.connect(_on_request_completed)
	get_response()
	
	number_of_actions = Globals.action_type.regular
	super._ready()
	add_child(dialogue)

func get_response() -> void:
	var url: String = "https://vgfishy.pythonanywhere.com/gemini?prompt=%s" % prompt
	$HTTPRequest.request(url)

func _on_request_completed(_result, _response_code, _headers, body) -> void:
	var json: Dictionary = JSON.parse_string(body.get_string_from_utf8())
	if json["candidates"][0].get("content", ""):
		employee_message = json["candidates"][0]["content"]["parts"][0]["text"].replace("\n", "")
	else:
		employee_message = "here are your options."
	dialogue.change_message([interactable_name + employee_message] as Array[String])

func _process(_delta):
	if visible and not_added:
		clear_dialogue()
		get_response()
		start_dialogue()
		not_added = false

func clear_dialogue() -> void:
	dialogue.label = employee_info
	dialogue.change_message([interactable_name + employee_message] as Array[String])
	$Background/VBoxContainer/Text.text = ""

func start_dialogue() -> void:
	dialogue.start_dialogue()
