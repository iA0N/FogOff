extends Node3D

var better_lightning = true
var iso = false
@onready var env = $WorldEnvironment.environment

func _ready():
	generate_trees()

func _input(event):
	if event is InputEventMouseButton and Input.is_action_just_released("LBM"):
		var space_state = get_world_3d().direct_space_state
		var cam = $demo_player/Camera3D
		var mousepos = get_viewport().get_mouse_position()

		var origin = cam.project_ray_origin(mousepos)
		var end = origin + cam.project_ray_normal(mousepos) * 200
		var query = PhysicsRayQueryParameters3D.create(origin, end)
		query.collide_with_areas = true

		var result = space_state.intersect_ray(query)
	
		print(result)
		$demo_player.set_movement_target(result.position)
		$demo_player.get_node("ChrKnight").look_at(result.position)
		$demo_player.get_node("ChrKnight").rotation_degrees.y += 180
		
	if Input.is_action_just_pressed("MWU"):
		if ($demo_player/Camera3D.position.y < 40):
			$demo_player/Camera3D.position.y += 0.2
		
	if Input.is_action_just_pressed("MWD"):
		if ($demo_player/Camera3D.position.y > 4):
			$demo_player/Camera3D.position.y -= 0.2
			
	$demo_player/Camera3D.look_at($demo_player.position)
	$demo_player.get_node("ChrKnight").rotation_degrees.x = 0
	$demo_player.get_node("ChrKnight").rotation_degrees.z = 0
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Control/VBoxContainer/Label3.text = "FPS: " + str(Engine.get_frames_per_second())
	
	if Input.is_action_just_released("T"):
		if better_lightning == true:
			better_lightning = !better_lightning
			$WorldEnvironment.environment.set_ssil_enabled(better_lightning)
			#$WorldEnvironment.environment.set_sdfgi_enabled(better_lightning)
			$Control/VBoxContainer/Label4.text = "Toggle SSIL: T (OFF)"
		else:
			better_lightning = !better_lightning
			$WorldEnvironment.environment.set_ssil_enabled(better_lightning)
			#$WorldEnvironment.environment.set_sdfgi_enabled(better_lightning)
			$Control/VBoxContainer/Label4.text = "Toggle SSIL: T (ON)"

	if Input.is_action_just_released("Q"):
		if !iso:
			$demo_player/Camera3D.current = false
			$demo_player/Camera3D_ISO.current = true
			iso = !iso
		else:
			$demo_player/Camera3D.current = true
			$demo_player/Camera3D_ISO.current = false
			iso = !iso

func generate_trees():
	var tree = preload("res://scenes/tree.tscn")
	randomize()
	var length: int = 160
	var width:  int = 160
	
	for l in range(0, length):
		for w in range (0, width):
			var chance = randi() % 30
			if chance == 0:
				var tree_instance = tree.instantiate()
				$NavigationRegion3D/Trees.add_child(tree_instance)
				tree_instance.current_frame = randi() % 5
				tree_instance.global_position = Vector3(l,0,w)
	await get_tree().physics_frame
	$NavigationRegion3D.bake_navigation_mesh();
