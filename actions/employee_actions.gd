extends action_layout

var dialogue: Control = preload("res://Dialouge/dialoge.tscn").instantiate()
@onready var employee_info: Label = $Background/VBoxContainer/Text
@onready var background: PanelContainer = $Background
@onready var view_port_size: Vector2 = Vector2(get_viewport().size)

func _ready():
	dialogue.label = employee_info
	interactable_name = "Joe: "
	dialogue.change_message([interactable_name + "says here are your options."] as Array[String])
	number_of_actions = Globals.action_type.regular
	
	start_dialogue()
	add_child(dialogue)
	super._ready()

func _process(_delta):
	calculate_center()

func calculate_center() -> void:
	
	# To get correct size
	background.global_position = Vector2.ZERO
	
	background.global_position = abs((background.size - view_port_size) / 4)
	#print(background.global_position)

func restart_dialogue() -> void:
	$Background/VBoxContainer/Text.text = ""

func start_dialogue() -> void:
	dialogue.start_dialogue()
