extends Node3D

var taken_positions = []
var meshes = []
var instance_count = 40
	
func generate():
	randomize()
	for i in $FloraMeshes.get_mesh_count():
		if i == 1: continue
		$FloraMeshes.set_current_frame(i)
		meshes.append($FloraMeshes.mesh)
	
	assert(instance_count * meshes.size() <= 400)
	
	for mesh in meshes:
		var multimeshinstance = MultiMeshInstance3D.new()
		var multimesh = MultiMesh.new()
		multimesh = MultiMesh.new()
		self.add_child(multimeshinstance)
		multimeshinstance.multimesh = multimesh
		multimesh.transform_format = MultiMesh.TRANSFORM_3D
		multimesh.mesh = mesh
		multimesh.instance_count = instance_count
		multimesh.visible_instance_count = multimesh.instance_count
		var instance_counter = 0
		for i in instance_count:
			var pos = Vector3(randi() % 16, 0, randi() % 16)
			while taken_positions.has(pos):
				pos = Vector3(randi() % 16, 0, randi() % 16)
			multimesh.set_instance_transform(instance_counter, Transform3D(Basis(), pos))
			taken_positions.append(pos)
			instance_counter+=1
