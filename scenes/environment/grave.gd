extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_detection_area_body_entered(body):
	if body.name == "demo_player":
		$Skeleton.chaseTarget()
