extends Node2D

signal item_destroyed
signal item_picked 
signal room_exited




var game_started = false
var game_over = false # defeat
var game_won = false # win

var player_at_exit = false

var time : float = 0.0

var items_destroyed : int = 0
var saved : Dictionary = {}
var totalPoints : int = 0

var hiScore = 0
var player

func _ready():
	randomize()
	$UI/EndResults.hide()
	$UI/Menu.show()
	$UI/How2Play.show()
	$UI/Menu/PlayButton.grab_focus()
	$MusicPlayer.play_ost("waiting")
	get_tree().paused = true
	player = get_node("Player")
	player.global_position = get_node("PlayerSpawn").global_position

	if hiScore == 0:
		$UI/Menu/HiScoreText.text = "No hi-score yet"
	else:
		$UI/Menu/HiScoreText.text = "Hi-score: %s" % hiScore

func start_game():
	game_started = true
	get_tree().paused = false
	$Timer.start()
	$MusicPlayer.play_ost("main")


func resume_game():
	get_tree().paused = false


func add_points(name : String, value : int):
	if saved.has(name):
		saved[name] += 1
	else:
		saved[name] = 1
		
	totalPoints += value


func _on_Player_died():
	game_over = true
	totalPoints += time * 3
	showEndResults()
	$MusicPlayer.play_ost("lose")
	get_tree().paused = true

func reset_game():
	# Reset things
	$Door/Sign/AnimationPlayer.play("hide")
	
	items_destroyed = 0
	totalPoints = 0
	saved = {}
	
	time = 0
	$UI/TimerText.text = str(0).pad_decimals(1)
	
	player_at_exit = false
	player.reset()
	player.global_position = get_node("PlayerSpawn").global_position
	
	get_node("Cauldron").reset()
	_delete_droplets()
	_delete_pools()
	
	get_node("Items").reset()
	
	game_over = false
	game_won = false
#	game_started = false
	
	$Timer.start()
	$MusicPlayer.play_ost("main")
	get_tree().paused = false

func _delete_pools():
	var counter = 0
	var nodes = get_tree().get_nodes_in_group("AcidPool")
	# Delete nodes as long as we find them
	for n in nodes:
		n.queue_free()
		counter += 1


func _delete_droplets():
	var counter = 0
	var nodes = get_tree().get_nodes_in_group("Droplet")
	# Delete nodes as long as we find them
	for n in nodes:
		n.queue_free()
		counter += 1

func reload_game():
	get_tree().reload_current_scene()
	get_tree().paused = false


func _on_Main_item_destroyed():
	items_destroyed += 1


func _on_Main_item_picked(item_name : String, item_value : int):
	add_points(item_name, item_value)
	$SoundPlayer.play_sound("pickup")


func _on_Door_body_entered(body):
	if body.is_in_group("Player"):
		player_at_exit = true
		$Door/Sign/AnimationPlayer.play("show")


func _on_Door_body_exited(body):
	if body.is_in_group("Player"):
		player_at_exit = false
		$Door/Sign/AnimationPlayer.play("hide")


func _on_Main_room_exited():
	get_tree().paused = true
	game_won = true
	totalPoints += time * 3
	$MusicPlayer.play_ost("win")
	showEndResults()


func resetEndResults():
	var items = $UI/EndResults/Items/Uniques.get_children()
	for i in items:
		i.get_node("Item").reset()
		i.get_node("Sprite").texture = null
		i.get_node("RichTextLabel").text = ""
	items = $UI/EndResults/Items/Commons.get_children()
	for i in items:
		i.get_node("Item").reset()
		i.get_node("Sprite").texture = null
		i.get_node("RichTextLabel").text = ""


func showEndResults():
	var summary
	var timeSpent
	var newHiScore = false
	
	if hiScore < totalPoints and game_won:
		hiScore = totalPoints
		newHiScore = true
		
	# Inform new hi-score
	
	if game_over:
		summary = "You took a dip into the ooze..."
		timeSpent = "Your demise took %s seconds." % time
	elif game_won:
		summary = "You managed to save yourself!"
		timeSpent = "Your escape took %s seconds." % time
	
	$UI/EndResults/SummaryText.text = summary
	
	$UI/EndResults/TimeSpentText.text = timeSpent
	showSavedItems()
	$UI/EndResults/TotalPointsText.text = "Score: %s" % totalPoints
	
	if newHiScore:
		$UI/EndResults/RecordText.show()
		$UI/Menu/HiScoreText.text = "Hi-score: %s" % hiScore
	else:
		$UI/EndResults/RecordText.hide()
	
	$UI/EndResults.show()
	$UI/EndResults/PlayAgainButton.grab_focus()


func showSavedItems():
	var u_index = 0
	var c_index = 0
	for k in saved.keys():
		var totalSaved = saved.get(k)
		if $Items.unique_items.has(k):
			var score = $UI/EndResults/Items/Uniques.get_child(u_index)
			var item = $Items.unique_items.get(k)
			score.get_node("Sprite").texture = item[2]
			score.get_node("RichTextLabel").text = String(totalSaved)
			u_index += 1
#			print("UNIQUE %s %s" % [k, totalSaved])
		
		if $Items.common_items.has(k):
			var score = $UI/EndResults/Items/Common.get_child(c_index)
			var item =  $Items.common_items.get(k)
			score.get_node("Sprite").texture = item[2]
			score.get_node("RichTextLabel").text = String(totalSaved)
			c_index += 1
#			print("%s %s" % [k, totalSaved])


func _on_Timer_timeout():
	time += 0.1
	$UI/TimerText.text = str(time).pad_decimals(1)


func _on_play_again():
	$UI/EndResults.hide()
#	get_tree().reload_current_scene()
	reset_game()
