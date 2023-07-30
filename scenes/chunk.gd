extends Node3D
var init_done = false
func _ready():
	randomize()
	$FloraGenerator.generate()
	generateEnvironment()
	
func _process(delta):
	pass

func generateEnvironment():
	
	var length: int = 16
	var width:  int = 16
	
	var miscEnvScenes = [
		preload("res://scenes/oldLog.tscn"),
		preload("res://scenes/logStump.tscn"),
		preload("res://scenes/stone.tscn"),
		preload("res://scenes/bush.tscn")
	]
	
	var treeScenes = [
		preload("res://scenes/tree.tscn")
	]
	
	for i in 2: await spawnEnvironmentInstance(miscEnvScenes)
	for i in 6: await spawnEnvironmentInstance(treeScenes)
	
	remove_child($Area3D)
	
	await get_tree().physics_frame
	await get_tree().physics_frame
	await get_tree().physics_frame
	
	$NavigationRegion3D.bake_navigation_mesh()
	init_done = true
	
func setTestingArea(instance: Node3D):
	$Area3D.position = instance.global_position
	$Area3D.position.y += 1
	$Area3D/CollisionShape3D.shape = instance.get_node("CollisionShape3D").shape
	$Area3D/CollisionShape3D.global_transform = instance.get_node("CollisionShape3D").global_transform
	
func spawnEnvironmentInstance(meshes):
	var selection_index = randi() % meshes.size()
	var pos = Vector3((randi() % 11) + 3, 0, (randi() % 11) + 3)
	var selected_scene = meshes[selection_index]
	var new_instance = selected_scene.instantiate()
	$NavigationRegion3D/Environment.add_child(new_instance)

	var found_position = false
	var counter = 0
	while not found_position:
		new_instance.position = pos
		new_instance.rotation_degrees.y = randi() % 360
		setTestingArea(new_instance)
		await get_tree().physics_frame
		await get_tree().physics_frame
		await get_tree().physics_frame
		if ($Area3D.get_overlapping_bodies().size() == 1):
			found_position = true
		pos = Vector3((randi() % 11) + 3, 0, (randi() % 11) + 3)
		counter+=1
		if counter == 10:
			self.remove_child(new_instance)
			found_position = true
		else:
			self.get_parent().tree_rids.append(new_instance.get_rid())
	
func regenerateTrees():
	while true:
		generateEnvironment()
		$NavigationRegion3D.bake_navigation_mesh();
		await get_tree().create_timer(2.0).timeout
		for n in $NavigationRegion3D/Environment.get_children():
			$NavigationRegion3D/Environment.remove_child(n)
			n.queue_free()
