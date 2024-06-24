extends Node2D


var backgrounds: Array[Texture2D] = [
	load("res://Assets/ALL OTHER ASSETS/nature dead.png"), 
	load("res://Assets/ALL OTHER ASSETS/nature greener.png"),
	load("res://Assets/ALL OTHER ASSETS/nature even greener.png"),
	load("res://Assets/ALL OTHER ASSETS/nature greenest.png")
]
@onready var current_background: Sprite2D = $"Backgrounds/Main Background"


func _ready() -> void:
	Globals.connect("action_completed", change_environment)


func change_environment() -> void:
	var current_environment_indicators: float = Globals.stats["environment_indicators"]
	if current_environment_indicators < 0:
		current_background.texture = backgrounds[0]
	elif current_environment_indicators < 0.5:
		current_background.texture = backgrounds[1]
	elif current_environment_indicators < 1:
		current_background.texture = backgrounds[2]
	else:
		current_background.texture = backgrounds[3]
