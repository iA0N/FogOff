extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var frame = (randi() % 5) + 1
	$FramedMeshInstance.set_current_frame(frame)
	if frame == 4:
		$GPUParticles3D.emitting = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
