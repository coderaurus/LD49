extends KinematicBody2D

signal died
signal hit

var speed : int = 200
var velocity : Vector2 = Vector2.ZERO
var jumping = false


func get_input():
	velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_down"):
		velocity = Vector2.DOWN
	elif Input.is_action_pressed("ui_up"):
		velocity = Vector2.UP
		
	if Input.is_action_pressed("ui_left"):
		velocity += Vector2.LEFT
	elif Input.is_action_pressed("ui_right"):
		velocity += Vector2.RIGHT

	velocity = velocity.normalized()

	if Input.is_action_just_pressed("jump") and !jumping:
		jump()
	
	if Input.is_action_just_pressed("ui_accept") and get_tree().current_scene.player_at_exit:
		get_tree().current_scene.emit_signal("room_exited")

func jump():
	print("Jump")
	jumping = true
	$CollisionShape2D.disabled = true
	yield(get_tree().create_timer(1.0), "timeout")
	$CollisionShape2D.disabled = false
	jumping = false


func _process(delta):
	get_input()
	move_and_slide(velocity * speed)


func _on_Player_hit():
	emit_signal("died")
	queue_free()
