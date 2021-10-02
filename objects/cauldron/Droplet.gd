extends RigidBody2D

var force_min = 50
var force_max = 175

var landing_min = 1.5
var landing_max = 2.5

var rng = RandomNumberGenerator.new()

onready var pool = preload("res://objects/cauldron/AcidPool.tscn")
onready var timer = get_node("LandingTimer")

func _ready():
	yield(get_tree(), "idle_frame")

func launch():
	rng.randomize()
	
	var force = rng.randf_range(force_min, force_max)
	
	var angle = rng.randf_range(PI*-0.25, PI*0.25)
	rotate(angle)
	
	var direction = Vector2.UP.rotated(angle)
	apply_central_impulse(direction * force)
	
	var time = rng.randf_range(landing_min, landing_max)
	timer.wait_time = time
	timer.start()
#	yield(get_tree().create_timer(time), "timeout")
#	land()


func land():
	var poolInstance = pool.instance()
	get_tree().current_scene.add_child(poolInstance)
	poolInstance.global_position = global_position
	queue_free()
