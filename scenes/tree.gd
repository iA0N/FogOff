extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	#self.position.y += 2
	$FramedMeshInstance.set_current_frame((randi() % 5) + 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
