extends Interactable


func _process(delta: float) -> void:
	if not has_action:
		$AnimationPlayer.stop()
	else:
		$AnimationPlayer.play("up_and_down")
	super._process(delta)
