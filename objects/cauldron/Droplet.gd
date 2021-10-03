extends RigidBody2D

var force_min = 75
var force_max = 250

var landing_min = 1.5
var landing_max = 3.0

var mass_min = 1.0
var mass_max = 4.5

var rng = RandomNumberGenerator.new()

onready var pool = preload("res://objects/cauldron/AcidPool.tscn")
onready var timer = get_node("LandingTimer")

func _ready():
	yield(get_tree(), "idle_frame")
	$AnimationPlayer.play("idle")
	z_index = 8

func launch():
	rng.randomize()
	
	var force = rng.randf_range(force_min, force_max)
	var angle = rng.randf_range(PI*-0.25, PI*0.25)
	var direction = Vector2.UP.rotated(angle)
	apply_central_impulse(direction * force)
	
	mass = rng.randf_range(mass_min, mass_max)
	
	var time = rng.randf_range(landing_min, landing_max)
	timer.wait_time = time
	timer.start()
	yield(get_tree().create_timer(time - 0.5), "timeout")
	
	z_index = 2
	$Shadow.show()
	$Shadow/AnimationPlayer.play("enlarge")
#	yield(get_tree().create_timer(time), "timeout")
#	land()


func land():
	var poolInstance = pool.instance()
	get_tree().current_scene.add_child(poolInstance)
	poolInstance.global_position = global_position
	queue_free()
