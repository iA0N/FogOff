extends Node3D

var taken_positions = []
var meshes = []
	
func getMeshes():
	for i in $TileMeshes.get_mesh_count():
		if i > 1: continue
		$TileMeshes.set_current_frame(i)
		meshes.append($TileMeshes.mesh)

func _ready():
	getMeshes()
	generateFirstLayer()
	generateSecondLayer()
	
func generateFirstLayer():
	for i in 50:
		var randpos = Vector3((randi() % 10) * 1.6, randf_range(0, 0.2), (randi() % 10) * 1.6)
		taken_positions.append(randpos)
		
	var multimeshinstance = MultiMeshInstance3D.new()
	var multimesh = MultiMesh.new()
	self.add_child(multimeshinstance)
	multimeshinstance.multimesh = multimesh
	
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.mesh = meshes[0]
	multimesh.instance_count = 50
	multimesh.visible_instance_count = multimesh.instance_count
	
	for i in multimesh.instance_count:
		multimesh.set_instance_transform(i, Transform3D(Basis(), taken_positions[i]))
		taken_positions[i] = Vector3(taken_positions[i].x, 0, taken_positions[i].z);
		

func generateSecondLayer():
	var multimeshinstance = MultiMeshInstance3D.new()
	var multimesh = MultiMesh.new()
	multimeshinstance.multimesh = multimesh
	self.add_child(multimeshinstance)

	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.mesh = meshes[1]
	multimesh.instance_count = 100
	multimesh.visible_instance_count = multimesh.instance_count

	var instance_count = 0
	for i in 10:
		for j in 10:
			var pos = Vector3(i*1.6, 0, j*1.6)
			if (taken_positions.count(pos) == 0):
				pos.y = randf_range(0, 0.2)
				multimesh.set_instance_transform(instance_count, Transform3D(Basis(), pos))
				instance_count+=1
