extends Node3D

func _ready():
	randomize()
	$FloraGenerator.generate()
	var chance_to_be_special = randi() % 14
	if chance_to_be_special > 0:
		generateTrees()
	else:
		$Graveyard.visible = true
		
	await get_tree().physics_frame
	await get_tree().physics_frame
	await get_tree().physics_frame
	$NavigationRegion3D.bake_navigation_mesh()
	
func _process(delta):
	pass

func generateTrees():
	var tree = preload("res://scenes/tree.tscn")
	var length: int = 16
	var width:  int = 16
	
	var taken_positions = []
	
	for i in randi() % 8:
		var pos = Vector3((randi() % 11) + 3, 2, (randi() % 11) + 3)
		var iterations = 0
		while iterations < 1000:
			var is_valid_pos = true
			for taken_position in taken_positions:
				if pos.distance_to(taken_position) < 4:
					is_valid_pos = false
					break
			if is_valid_pos: break
			pos = Vector3((randi() % 11) + 3, 2, (randi() % 11) + 3)
			iterations += 1
		if iterations < 1000:
			var tree_instance = tree.instantiate()
			tree_instance.current_frame = randi() % 5
			tree_instance.rotation_degrees.y = randi() % 360
			$NavigationRegion3D/Trees.add_child(tree_instance)
			tree_instance.position = Vector3(pos)
			taken_positions.append(pos)
			self.get_parent().tree_rids.append(tree_instance.get_node("TreeArea").get_rid())
	
func regenerateTrees():
	while true:
		generateTrees()
		$NavigationRegion3D.bake_navigation_mesh();
		await get_tree().create_timer(2.0).timeout
		for n in $NavigationRegion3D/Trees.get_children():
			$NavigationRegion3D/Trees.remove_child(n)
			n.queue_free()
