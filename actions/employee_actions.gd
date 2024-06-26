extends action_layout

var dialogue: Control = preload("res://Dialouge/dialoge.tscn").instantiate()
var not_added: bool = true
@onready var employee_info: Label = $Background/VBoxContainer/Text
@onready var background: PanelContainer = $Background
@onready var view_port_size: Vector2 = Vector2(get_viewport().size)

func _ready():
	dialogue.label = employee_info
	interactable_name = "Joe: "
	dialogue.change_message([interactable_name + "Here are your options."] as Array[String])
	
	number_of_actions = Globals.action_type.regular
	super._ready()

func _process(_delta):
	if visible and not_added:
		add_child(dialogue)
		start_dialogue()
		not_added = false

func restart_dialogue() -> void:
	$Background/VBoxContainer/Text.text = ""

func start_dialogue() -> void:
	dialogue.start_dialogue()
