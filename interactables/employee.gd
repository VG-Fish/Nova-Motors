extends Interactable

@onready var employee: AnimatedSprite2D = $"Object Collision Area/AnimatedSprite2D"

func _ready() -> void:
	actions = preload("res://actions/employee_actions.tscn").instantiate()
	employee.animation = "idle"
	super._ready()

func _process(delta: float) -> void:
	if not has_action:
		$AnimationPlayer.stop()
	else:
		$AnimationPlayer.play("up_and_down")
		
	super._process(delta)
	
	if actions.visible:
		employee.play("talking")
	else:
		employee.play("idle")
		
