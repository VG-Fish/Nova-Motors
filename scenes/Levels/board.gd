extends Level

var board_dialogue: Control = preload("res://actions/Base/board_actions.tscn").instantiate()

func _ready() -> void:
	board_dialogue.connect("action_done", remove_action)

func remove_action():
	board_dialogue.visible = false
	board_dialogue.restart_dialogue()
	remove_child(board_dialogue)

func add_dialogue() -> void:
	if has_node("Actions"):
		return
	board_dialogue.visible = true
	board_dialogue.start_dialogue()
	add_child(board_dialogue)
	# To skip to next day
	Globals.amount_of_actions -= 2
