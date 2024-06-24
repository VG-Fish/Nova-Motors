extends VBoxContainer
class_name action

# Supposed to be {"stat" (String): impact (float), ...}. Example: {"profit": 0.1}
var impacted_stats: Dictionary = {}
signal close(type)

func _on_button_button_down() -> void:
	for stat in impacted_stats:
		var impact = impacted_stats[stat]
		Globals.add_value_to_stat(stat, impact)
	Globals.amount_of_actions -= 1
	close.emit("stat")
