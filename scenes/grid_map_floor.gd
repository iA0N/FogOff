extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	generate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate():
	
	var length: int = 100
	var width:  int = 100
	
	for l in range(0, length):
		for w in range (0, width):
			var side = randi() % 10   
			#if side > 0: side = 2
			#else: side = 0
			$GridMap.set_cell_item(Vector3(l,1,w), randi() % 2)
			# TODO michi meint des is kacke und soll mehr als drei zeilen brauchen
