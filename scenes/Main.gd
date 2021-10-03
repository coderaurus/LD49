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


func _ready():
	randomize()
	$UI/Menu/PlayButton.grab_focus()
	$MusicPlayer.play_ost("waiting")
	get_tree().paused = true


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

func showEndResults():
	var summary
	var timeSpent
	
	if game_over:
		summary = "You took a dip into the ooze..."
		timeSpent = "Your demise took %s seconds." % time
	elif game_won:
		summary = "You managed to save yourself!"
		timeSpent = "Your escape took %s seconds." % time
	
	$UI/EndResults/SummaryText.text = summary
	
	$UI/EndResults/TimeSpentText.text = timeSpent
	showSavedItems()
	$UI/EndResults/TotalPointsText.text = "Total points: %s" % totalPoints
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
	get_tree().reload_current_scene()
