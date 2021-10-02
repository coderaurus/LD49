extends Node2D


export var unique_items = {}
export var common_items = {}


onready var uniques : Node2D = get_node("Uniques")
onready var commons : Node2D = get_node("Commons")

var rng = RandomNumberGenerator.new()


func _ready():
	rng.randomize()
	yield(get_tree(), "idle_frame")
	init()


func init():
	
	# Common items
	for i in commons.get_child_count():
		var child = commons.get_child(i)
		if rng.randf() > 0.5 and commons.get_child_count() > 50:
			child.queue_free()
		else: 
			var item = child.get_node("Item")
			var selectedItem = common_items.get(common_items.keys()[rng.randi_range(0, common_items.size()-1)])
			item.set_values(selectedItem)

	# Unique items
	for i in uniques.get_child_count():
		var child = uniques.get_child(i)
		var placed = false
		
		var item = child.get_node("Item")
		var selectedItem = unique_items.get(unique_items.keys()[rng.randi_range(0, unique_items.size()-1)])
		# Is item already placed?
		item.set_values(selectedItem)
