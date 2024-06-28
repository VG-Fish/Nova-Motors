extends Control

# If this space bar is pressed 3 times, the Bad Apple tab will show
var amount_of_times_space_is_pressed: int = 0
# Because _process() happens very fast, we want delta to be over a certain value 
# to make sure the player pressed space 3 times
var can_press: bool = true
var noise: FastNoiseLite = FastNoiseLite.new()
var customer_review_texts: Array = [
	{
		"Text": "This is a bad company that pollutes the environment.",
		"Rating": "1",
		"Name": "Average Joe"
	},
	{
		"Text": "This is a terrible company that hates its employees.",
		"Rating": "0",
		"Name": "Some Guy"
	},
	{
		"Text": "This is a atrocious company that scams its customers.",
		"Rating": "0",
		"Name": "anonymous"
	},
	{
		"Text": "This is a morally repugnant company that will hopefully go bankrupt.",
		"Rating": "-1",
		"Name": "Bill"
	},
]

func _ready() -> void:
	Globals.mode = "hard"
	if Globals.mode != "hard":
		$"Computer Tabs".set_tab_hidden(1, true)
	$"Computer Tabs/Bad Apple/VideoStreamPlayer".paused = true
	$"Computer Tabs".set_tab_hidden(2, true)
	
#	var highest_sentiment: float = 0.4
#	for i in Globals.customer_sentiment_range:
#		if Globals.GRADE >= i:
#			highest_sentiment = i
	
	for i in range(4):
		var customer_review_label: Label = $"Computer Tabs/Customer Reviews/Reviews".get_child(i)
		customer_review_label.text = customer_review_texts[i].Text
		customer_review_label.text += "\nBy %s. I give this company a rating of %s/5.\n\n" % [customer_review_texts[i].Name, customer_review_texts[i].Rating]

func _process(_delta):
	if Input.is_action_pressed("up") and can_press:
		can_press = false
		amount_of_times_space_is_pressed += 1
		$"Space Bar Timer".start()
	if amount_of_times_space_is_pressed >= 3:
		$"Computer Tabs".set_tab_hidden(2, false)

func _on_computer_tabs_tab_changed(tab):
	if tab == 2:
		$"Computer Tabs/Bad Apple/VideoStreamPlayer".paused = false
	else:
		$"Computer Tabs/Bad Apple/VideoStreamPlayer".paused = true

func _on_space_bar_timer_timeout():
	can_press = true

func _on_button_pressed():
	SceneSwitcher.show_scene(SceneSwitcher.SCENE.OFFICE)
