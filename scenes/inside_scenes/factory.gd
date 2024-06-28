extends Node2D

var backgrounds: Array[Texture2D] = [
	load("res://New Assets/Nature/dead_nature.png"), 
	load("res://New Assets/Nature/semi_dead_nature.png"),
	load("res://New Assets/Nature/nature.png"),
	load("res://New Assets/Nature/good_nature.png")
]
@onready var current_background: Sprite2D = $"Backgrounds/Main Background"

func _ready() -> void:
	Globals.connect("action_completed", change_environment)

func change_environment() -> void:
	var current_environment_indicators: float = Globals.stats["environment_indicators"]
	if current_environment_indicators < 25:
		current_background.texture = backgrounds[0]
	elif current_environment_indicators < 50:
		current_background.texture = backgrounds[1]
	elif current_environment_indicators < 75:
		current_background.texture = backgrounds[2]
	else:
		current_background.texture = backgrounds[3]
