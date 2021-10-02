extends KinematicBody2D

signal died
signal hit

onready var anim = get_node("AnimationPlayer")


var speed : int = 175
var velocity : Vector2 = Vector2.ZERO
var jumping = false
var dying = false

func _ready():
	anim.play("idle")


func get_input():
	velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_down"):
		velocity = Vector2.DOWN
	elif Input.is_action_pressed("ui_up"):
		velocity = Vector2.UP
		
	if Input.is_action_pressed("ui_left"):
		velocity += Vector2.LEFT
		$Sprite.flip_h = true
	elif Input.is_action_pressed("ui_right"):
		velocity += Vector2.RIGHT
		$Sprite.flip_h = false

	velocity = velocity.normalized()
	
	

	if Input.is_action_just_pressed("jump") and !jumping:
		jump()
	
	if Input.is_action_just_pressed("ui_accept") and get_tree().current_scene.player_at_exit:
		get_tree().current_scene.emit_signal("room_exited")
		
	if !jumping and !dying:
		if velocity != Vector2.ZERO:
			anim.play("move")
		else:
			anim.play("idle")

func jump():
#	$CollisionShape2D.disabled = true
	anim.advance(0)
	anim.play("jump")
	jumping = true
	print("Jumping")
	yield(anim, "animation_finished")
	jumping = false
	print("Landed")	
	#$CollisionShape2D.disabled = false


func _process(delta):
	get_input()
	move_and_slide(velocity * speed)


func _on_Player_hit():
	if !jumping:
		dying = true
		anim.advance(0)
		anim.play("die")
		yield(anim,"animation_finished")
		emit_signal("died")
		queue_free()
