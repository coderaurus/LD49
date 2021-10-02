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
var points : Dictionary = {}
var totalPoints : int = 0


func _ready():
	randomize()
	$UI/Menu/PlayButton.grab_focus()
	get_tree().paused = true


func start_game():
	game_started = true
	get_tree().paused = false
	$Timer.start()


func resume_game():
	get_tree().paused = false


func add_points(name : String, value : int):
	if points.has(name):
		points[name] += value
	else:
		points[name] = value
		
	totalPoints += value


func _on_Player_died():
	game_over = true
	$UI/EndResults.show()
	get_tree().paused = true
#	reload_game()


func reload_game():
#	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().reload_current_scene()
	get_tree().paused = false


func _on_Main_item_destroyed():
	items_destroyed += 1
#	print(items_destroyed)


func _on_Door_body_entered(body):
	if body.is_in_group("Player"):
		player_at_exit = true
#		print(player_at_exit)


func _on_Door_body_exited(body):
	if body.is_in_group("Player"):
		player_at_exit = false
#		print(player_at_exit)


func _on_Main_room_exited():
	get_tree().paused = true
	game_won = true
	$UI/EndResults.show()
#	print(totalPoints)
#	reload_game()


func _on_Main_item_picked(item_name : String, item_value : int):
	add_points(item_name, item_value)


func _on_Timer_timeout():
	time += 0.1
	$UI/TimerText.text = str(time).pad_decimals(1)


func _on_play_again():
	$UI/EndResults.hide()
	get_tree().reload_current_scene()
