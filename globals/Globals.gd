extends Node

# VARIABLES
# Stock related
var noise: FastNoiseLite = FastNoiseLite.new()
const initial_stock_price = 3
var stock_price: float = initial_stock_price + randf() * 0.05:
	set(value):
		stock_price = clamp(value, 0.5, INF)
var stat_multiplier: float = 1.0
var make_negative_threshold: float = 0.5
var noise_multiplier: float = 1.0
var stock_price_last_20_days: Array[float] = []
enum CALCULATE_TYPE {SECOND = 500, MINUTE = 250, HOUR = 25, DAY = 10}

# Player Related
var stats: Dictionary = { "profit": 0, 
	"public_relations": 0, "employee_friendliness": 0, 
	"product_quality": 0, "environment_indicators": 0
}
var local_multiplayer: bool = false:
	set(value):
		local_multiplayer = value
		if value:
			local_multiplayer_true.emit()

var days_since_start: int = 0:
	set(value):
		days_since_start = value
		stock_price += calculate_stock_price(CALCULATE_TYPE.DAY)
		day_changed.emit()
		DayChange.play_animation()
		if days_since_start >= DAYS_THRESHOLD:
			lose()
			
var amount_of_actions: int = 3:
	set(value):
		amount_of_actions = value
		action_completed.emit()
		if amount_of_actions <= 0:
			days_since_start += 1
			GRADE = update_grade()
			# FIXME, HACK: Find proper fix. For some reason, after a day change, something is decreasing actions automatically.
			# but I don't want to fix that right now.
			amount_of_actions = 3
		SaveGame.save_game(current_game)
			
# It's in ALL CAPS to make it different from all the other grade related things
var GRADE: float = update_grade():
	set(value):
		GRADE = value
		if GRADE >= GRADE_THRESHOLD:
			win()

# Game Related
var mode: String = "easy"
enum action_type {placeholder = -1, board = 2, regular = 4}
var texts: Array[Dictionary] = []
var DAYS_THRESHOLD: int = 365
var GRADE_THRESHOLD: float = 90
var current_game: int 

# Customer Review Related
var customer_sentiment_range: Array[float] = [0.4, 0.55, 0.85]
var json: JSON = JSON.new()
var actions_text: String = FileAccess.open("res://globals/actions_text.txt", FileAccess.READ).get_as_text()
var customer_review_texts: Array = str_to_var(actions_text)

# Pause Menu Related
var paused: bool = false:
	set(value):
		await get_tree().create_timer(0.05).timeout
		paused = value

# InputMap Related
var config: ConfigFile = ConfigFile.new()

# SIGNALS
signal day_changed
signal action_completed
signal local_multiplayer_true

# FUNCTIONS
func _ready() -> void:
	DisplayServer.window_set_title("NOVA MOTORS")
	for i in range(20):
		stock_price_last_20_days.append(calculate_stock_price(CALCULATE_TYPE.DAY))
	

func load_default_input_map_settings() -> void:
	load_config_file("res://saves/input_map.cfg", "God")


func save_keybinding(save_action: String, event: InputEvent) -> void:
	var err = config.load_encrypted_pass("res://saves/user_input_map.cfg", "God")

	# If the file didn't load, ignore it.
	if err != OK:
		print("Error reading user config file.")
		return
	
	for input in config.get_section_keys("InputMap"):
		if input != save_action:
			config.set_value("InputMap", input, InputMap.action_get_events(input))
		else:
			InputMap.action_erase_events(input)
			InputMap.action_add_event(input, event)
			config.set_value("InputMap", input, InputMap.action_get_events(input))
		
	config.save_encrypted_pass("res://saves/user_input_map.cfg", "God")
	load_config_file("res://saves/user_input_map.cfg", "God")
	

func load_config_file(file_name: String, passcode: String) -> void:
	var err = config.load_encrypted_pass(file_name, passcode)

	# If the file didn't load, ignore it.
	if err != OK:
		return
	
	for input in config.get_section_keys("InputMap"):
		InputMap.action_erase_events(input)
		var events = config.get_value("InputMap", input)
		for event in events:
			InputMap.action_add_event(input, event)


# When player fails the game after passing DAYS_THRESHOLD
func lose() -> void:
	WinLoseScreen.lose()


# When player wins the game after passing GRADE_THRESHOLD
func win() -> void:
	WinLoseScreen.lose()

	TrackOfGames.leaderboard_counter += 1
	TrackOfGames.leaderboard.append([TrackOfGames.leaderboard_counter, GRADE])
	SaveGame.save_track_of_games()


func update_grade() -> float:
	var res: float = 0.0
	for stat in stats:
		var value: float = stats[stat]
		res += value * 0.2
	return res


func calculate_stock_price(time_type: CALCULATE_TYPE) -> float:
	noise.noise_type = FastNoiseLite.TYPE_VALUE
	var sum: float = 0.0
	for j in range(100):
		var noise_value: float = abs(noise.get_noise_1d(j) * stat_multiplier)
		if randf() > make_negative_threshold: 
			noise_value *= -noise_multiplier
		else:
			noise_value *= noise_multiplier + 0.1
		sum += noise_value
	return sum * 1 / time_type


func add_value_to_stat(stat: String, value: float) -> void:
	var current_grade: float = update_grade() 
	# NOTE: To make the game longer and add variability to the change.
	stats[stat] += (value * 15) + randf_range(-1, 1)
	stats[stat] = clamp(stats[stat], 0, 100)
	# NOTE: To make the game longer and add variability to the change.
	stats[stat] += (value * 15) + randf_range(-1, 1)
	stats[stat] = clamp(stats[stat], 0, 100)
	change_stock_multipliers(current_grade)


func change_stock_multipliers(previous_grade: float) -> void:
	# For stat multiplier
	var current_grade: float = update_grade() 
	var previous_stat_multiplier: float = stat_multiplier
	stat_multiplier += (current_grade - previous_grade) 

	# For make negative threshold
	var previous_make_negative_threshold: float = make_negative_threshold
	make_negative_threshold += stat_multiplier - previous_stat_multiplier
	make_negative_threshold = clamp(make_negative_threshold, 0.1, 0.5)

	# For noise_multiplier
	noise_multiplier += make_negative_threshold - previous_make_negative_threshold 
	noise_multiplier = clamp(noise_multiplier, 0.1, 0.7)
