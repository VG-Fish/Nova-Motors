extends CharacterBody2D


const SPEED = 350
var interactable_nearby: bool = false
var interactable_area: Area2D
signal show_interactable_actions(area)
@onready var player: AnimatedSprite2D = $Player


func _ready() -> void:
	player.play()
	

func _process(_delta) -> void:
	# Movement
	var direction_x = Input.get_axis("left", "right")
	# Animation
	if direction_x == -1:
		player.animation = "left"
	elif direction_x == 0:
		player.animation = "idle"
	else:
		player.animation = "right"
	velocity.x = direction_x * SPEED
	move_and_slide()


	if Input.is_action_pressed("enlarge") and interactable_nearby:
		show_interactable_actions.emit(interactable_area)


func _on_area_2d_area_entered(area) -> void:
	interactable_area = area
	interactable_nearby = true


func _on_area_2d_area_exited(_area) -> void:
	interactable_area = null
	interactable_nearby = false
