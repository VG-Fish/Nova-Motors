extends Interactable

func _ready() -> void:
	actions = preload("res://actions/machine_actions.tscn").instantiate()
	super._ready()

func _process(delta: float) -> void:
	if not has_action:
		$AnimationPlayer.stop()
	else:
		$AnimationPlayer.play("up_and_down")
	super._process(delta)
