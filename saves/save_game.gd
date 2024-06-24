extends Node


var saves: Array[String] = ["saves1", "saves2", "saves3", "saves4", "saves5"]


func save() -> Dictionary:
	# Ensure no buffoonery 
	Globals.paused = !Globals.paused
	
	# Globals Stats
	var save_dict: Dictionary = {
		"Globals": {
			"stats": Globals.stats,
			"days_since_start": Globals.days_since_start,
			"amount_of_actions": Globals.amount_of_actions,
			"GRADE": Globals.GRADE,
			"mode": Globals.mode,
			"stock_price": Globals.stock_price,
			"stat_multipier": Globals.stat_multiplier,
			"make_negative_threshold": Globals.make_negative_threshold,
			"noise_multiplier": Globals.noise_multiplier,
			"stock_price_last_20_days": Globals.stock_price_last_20_days,
		},
	}
	
	# Level data
	save_dict["Levels"] = {}
	for node in get_tree().get_nodes_in_group("Persist"):
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		if "save" in node:
			save_dict["Levels"][node.name] = node.save()
	
	return save_dict

func save_game(index: int) -> void:
	var save_file: FileAccess = FileAccess.open_encrypted_with_pass("res://%s.save" % saves[index], FileAccess.WRITE, "Family")

	var json_save_data: String = JSON.stringify(save()) 

	save_file.store_line(json_save_data)


func load_game(index: int) -> void:
	save_game(index)
	if not FileAccess.file_exists("res://%s.save" % saves[index]):
		print("%s file doesn't exist" % saves[index])
		return
		
	var save_file: FileAccess = FileAccess.open_encrypted_with_pass("res://%s.save" % saves[index], FileAccess.READ, "Family")
	var file_length: int = save_file.get_length()
	var data: Dictionary
	
	while save_file.get_position() < file_length:
		var json_save_data = save_file.get_line()
		var json = JSON.new()

		if json.parse(json_save_data) == OK:
			data = json.get_data()
		else:
			print(json.get_error_message())
	
	if not data:
		return
	update_variables(data)


func update_variables(game_save: Dictionary) -> void:
	for stat in game_save["Globals"].keys():
		Globals.set(stat, game_save["Globals"][stat])
	
	# Levels (Factory Scene, etc.)
	var levels: Dictionary = game_save["Levels"]
	
	for level in levels:
		# Make new Level (cause we deleted before to avoid clones)
		var level_data: Dictionary = levels[level]
		var new_level: Node2D = load(level_data["path"]).instantiate()
		# call_deferred adds the new_level when level_data["parent"] isn't busy, without it, godot would start complaining
		get_node(level_data["parent"]).add_child.call_deferred(new_level)
		new_level["days_passed"] = level_data["days_passed"]
		
		# Update Player in Level
		var player: CharacterBody2D = load(level_data["$Player"]["path"]).instantiate()
		# global_position is the absolute position, I did this so that wacky stuff with relative position wouldn't happen
		player.global_position.x = level_data["$Player"]["x"]
		player.global_position.y = level_data["$Player"]["y"]
		new_level.add_child(player)

		# Update Interactables in Level
		for interactable_object in level_data["interactables"].keys():
			var interactable_object_data: Dictionary = level_data["interactables"][interactable_object]
			var new_interactable_object: Node2D = load(interactable_object_data["path"]).instantiate()

			# In case of door
			if interactable_object_data.has("IGNORE"):
				continue
			# Interactable Data (such as variables)
			# This updates ignore meter
			new_interactable_object.find_child("Ignore Meter").value = interactable_object_data["$Ignore Meter"].value
			for stat in interactable_object_data:
				new_interactable_object.set(stat, interactable_object_data[stat])
			
			# Interactable Actions Data
			new_interactable_object["actions"] = load("res://actions/Base/action_layout.tscn").instantiate() as Control
			# I had to call _ready() or godot would start complaining, I assume that's because I programmed the action_layout 
			# to start adding actions in _ready(), otherwise the actions wouldn't exist
			new_interactable_object["actions"]._ready()
			new_interactable_object["actions"]["number_of_actions"] = interactable_object_data["actions"]["number_of_actions"]
			for i in range(new_interactable_object["actions"]["number_of_actions"]):
				# This updates each action's text that we randomly generated before, I should probably not do the get_child(0)... 
				# nonsense, but that's too much work
				new_interactable_object["actions"]["actions"][i].find_child("Text").text = interactable_object_data["actions"]["actions_text"][i]


func save_track_of_games() -> void:
	var save_file: FileAccess = FileAccess.open_encrypted_with_pass("res://track_of_games.save", FileAccess.WRITE, "Friends")

	var json_save_data: String = JSON.stringify({
		"has_game": TrackOfGames.has_game,
		"create_has_game": TrackOfGames.create_has_game,
		"leaderboard": TrackOfGames.leaderboard,
		"leaderboard_counter": TrackOfGames.leaderboard_counter
	}) 
	
	save_file.store_line(json_save_data)


func load_track_of_games() -> void:
	save_track_of_games()
	if not FileAccess.file_exists("res://track_of_games.save"):
		print("Tracking Games file doesn't exist")
		return

	var save_file: FileAccess = FileAccess.open_encrypted_with_pass("res://track_of_games.save", FileAccess.READ, "Friends")
	var file_length: int = save_file.get_length()
	var data: Dictionary
	
	while save_file.get_position() < file_length:
		var json_save_data = save_file.get_line()
		var json = JSON.new()

		if json.parse(json_save_data) == OK:
			data = json.get_data()
		else:
			print(json.get_error_message())

	if not data:
		return
		
	TrackOfGames.create_has_game = data["create_has_game"]
	TrackOfGames.has_game = data["has_game"]
	TrackOfGames.leaderboard = data["leaderboard"]
	TrackOfGames.leaderboard_counter = data["leaderboard_counter"]
