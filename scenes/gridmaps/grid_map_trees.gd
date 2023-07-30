extends Node3D

var trees = []
var length: int = 80
var width:  int = 80

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	generate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate():
	for l in length:
		var tmp = []
		tmp.resize(80)
		tmp.fill(0)
		trees.append(tmp)
	
	for l in length:
		for w in width:
			var tree_chance = randi() % 10
			if tree_chance == 0 && checkNoTreeAdjacent(l, w):
				var tree_index = randi() % 6
				trees[l][w] = 1
				$GridMap.set_cell_item(Vector3(l,1,w), tree_index)
			
			
func checkNoTreeAdjacent(l, w):
	var tmp = 0
	if w != 0: tmp += trees[l][w-1]
	if w != width-1: tmp += trees[l][w+1]
	if l != length-1: tmp += trees[l+1][w]
	if l != 0: trees[l-1][w]
	return true if tmp == 0 else false
			
