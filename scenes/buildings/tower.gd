extends StaticBody3D

var bodies_in = 0
var placeable = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	bodies_in += 1
	if bodies_in > 1:
		$MeshInstance3D.visible = true
		placeable = false
	else:
		placeable = true
	print("bodies: " + str(bodies_in))


func _on_area_3d_body_exited(body):
	bodies_in -= 1
	print("bodies: " + str(bodies_in))
	if bodies_in == 1:
		$MeshInstance3D.visible = false
		placeable = true
	else:
		placeable = false
