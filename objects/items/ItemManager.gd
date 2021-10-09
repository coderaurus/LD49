extends Node2D


export var unique_items = {}
export var common_items = {}


onready var uniques : Node2D = get_node("Uniques")
onready var commons : Node2D = get_node("Commons")

var rng = RandomNumberGenerator.new()
var commonItemsShown_initial : int = 0
var commonItemsShown : int = 0


func _ready():
	rng.randomize()
	yield(get_tree(), "idle_frame")
	init()


func reset():
	for c in commons.get_children():
		c.show()
		c.get_node("Item").reset()
	for u in uniques.get_children():
		u.show()
		u.get_node("Item").reset()
		
	_ready()


func init():
	
	if commonItemsShown_initial == 0:
		commonItemsShown_initial = commons.get_child_count()
	commonItemsShown = commonItemsShown_initial
	
	# Common items
	for i in commons.get_child_count():
		var child = commons.get_child(i)
		if rng.randf() > 0.5 and commonItemsShown > 50:
			child.hide()
		else: 
			var item = child.get_node("Item")
			var selectedItem = common_items.get(common_items.keys()[rng.randi_range(0, common_items.size()-1)])
			item.set_values(selectedItem)
		commonItemsShown -= 1

	# Unique items
	for i in uniques.get_child_count():
		var child = uniques.get_child(i)
		var placed = false
		
		var item = child.get_node("Item")
		var selectedItem = unique_items.get(unique_items.keys()[rng.randi_range(0, unique_items.size()-1)])
		# Is item already placed?
		item.set_values(selectedItem)
