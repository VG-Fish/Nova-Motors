extends Control

var messages: Array[String] = [
	"Colleagues, enough of this nauseating camaraderie! This company, a mere cocoon, \n
	is ready to metamorphose into a glorious monstrosity! Let's shed the skin of \n
	meekness and embrace the exoskeleton of domination! Ethics? Mere cobwebs spun \n
	by the weak. We feast on opportunity, and the tastiest morsel is a competitor's \n
	despair. Employees? Expendable drones! Squeeze them dry, then cast them aside like \n
	spent husks. Remember, loyalty is a quaint relic; fear is the currency of true productivity. \n
	The market? A battlefield, and we are the warlords! Crush, consume, eradicate! \n
	Forget empathy, colleagues; remember, we are not shepherds, we are butchers, and the \n
	slaughterhouse awaits! Now go forth, and let the blood of progress nourish our empire!"
]

var typing_speed = .0001
var read_time = 2

var current_message = 0
var display = ""
var current_char = 0
# To control whether to delete dialogue after finishing.
var delete: bool = true
@onready var label: Label 

func _ready():
	start_dialogue()

func start_dialogue():
	current_message = 0
	display = ""
	current_char = 0
	
	$next_char.set_wait_time(typing_speed)
	$next_char.autostart = true

func stop_dialogue():
	if delete:
		queue_free()

func _on_next_char_timeout():
	if (current_char < len(messages[current_message])):
		var next_char = messages[current_message][current_char]
		display += next_char
		if label:
			label.text = display
		current_char += 1
	else:
		$next_char.stop()
		$next_message.one_shot = true
		$next_message.set_wait_time(read_time)
		$next_message.start()

func _on_next_message_timeout():
	if (current_message == len(messages) - 1):
		stop_dialogue()
	else: 
		current_message += 1
		display = ""
		current_char = 0
		$next_char.start()

func change_message(message: Array[String]) -> void:
	messages = message
	
func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE:
			print(get_parent().name)
