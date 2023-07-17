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
			var spawn_chance = randi() % 3
			if spawn_chance == 0:
				var index = randi() % 5
				if index == 1: index = 2
				$GridMap.set_cell_item(Vector3(l,1,w), index)
