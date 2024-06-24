extends Control

var dialogue: Control = preload("res://Dialouge/dialoge.tscn").instantiate()
var message: Array[String] = [
	"Hello, welcome to Nova Motors! A game where you can flaunt and hone your entrepreneurial skills. \
	You have just inherited a massive automobile company that is losing money hand over fist, and it is your job to save it by taking precise actions. \
	You will have to keep your stock price high (in hard mode) as well as having strong employee relations, environmental awareness, public relations, product quality, and better profitability. \
	However, you do not do this without adversity, as your antagonist will be the board of directors who are doing everything in their power to make it as hard for you as possible to keep the company afloat. \
	They will give you difficult tasks and are a representation of adversity that you might face in a real life endeavor. \
	Each action given to you can impact your statistics and stock in many ways both positive and negative. \
	This means you have to interpret each action and decide whether it would be good for your overall progress. \
	For example, if you choose to go to your employee and initiate(by left-clicking on them, you must be nearby too): “greater production in the electric vehicle department”, your perception and environmental awareness statistics will increase, but your profit and your stock will decrease as electric vehicles are still a small portion of the market. \
	You have to balance all of these statistics to make sure your company is the best that it can be, and that means making sacrifices and tough decisions. \
	With all of that, get out there and make nova motors into one of the most successful companies out there, and hopefully a Fortune 500! \
	To play the game, use A and D to move to the left and right, left click to click on objects, and P or ESC to access the pause menu. \
	You can click on doors to go to other rooms. Your progress will automatically be saved."
]
var not_in_tutorial: bool = true
@onready var employee_info: Label = $Background/VBoxContainer/Text
@onready var background: PanelContainer = $Background
@onready var view_port_size: Vector2 = Vector2(get_viewport().size)

func _ready():
	add_child(dialogue)

func ready_dialogue() -> void:
	dialogue.label = employee_info
	message[0].replace("\n", "")
	dialogue.change_message(message)

func _process(delta):
	if SceneSwitcher.get_scene_shown() == get_parent().scene_file_path and not_in_tutorial:
		ready_dialogue()
		start_dialogue()
		not_in_tutorial = false
		visible = true
	elif SceneSwitcher.get_scene_shown() != get_parent().scene_file_path:
		dialogue.clear_text()
		dialogue.start_dialogue()
		not_in_tutorial = true
	if not not_in_tutorial:
		calculate_center()

func calculate_center() -> void:
	# To get correct size
	background.global_position = Vector2.ZERO
	
	background.global_position = abs((background.size - view_port_size) / 2)

func restart_dialogue() -> void:
	$Background/VBoxContainer/Text.text = ""

func start_dialogue() -> void:
	dialogue.start_dialogue()

func _on_button_pressed():
	visible = false
