extends Node3D

var better_lightning = true
var iso = false
@onready var env = $WorldEnvironment.environment

var tree_rids = []

func _ready():
	for i in 10:
		for j in 10:
			var chunk_scene = load("res://scenes/chunk.tscn")
			var chunk_instance = chunk_scene.instantiate()
			add_child(chunk_instance)
			chunk_instance.position = Vector3((8 + i * 16), 0, (8 + j * 16))

	var default_3d_map_rid: RID = get_world_3d().get_navigation_map()
	NavigationServer3D.map_set_edge_connection_margin(default_3d_map_rid, 1.2)

func _input(event):
	if event is InputEventMouseButton and Input.is_action_just_released("LBM"):
		var space_state = get_world_3d().direct_space_state
		var cam = $demo_player/Camera3D
		var mousepos = get_viewport().get_mouse_position()

		var origin = cam.project_ray_origin(mousepos)
		var end = origin + cam.project_ray_normal(mousepos) * 200
		var query = PhysicsRayQueryParameters3D.create(origin, end)
		query.collide_with_areas = true
		query.set_exclude(tree_rids)
		var result = space_state.intersect_ray(query)
		$demo_player.set_movement_target(result.position)
		$demo_player.get_node("ChrKnight").look_at(result.position)
		$demo_player.get_node("ChrKnight").rotation_degrees.y += 180
		print(result)
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
#	$demo_player/Camera3D/RayCast3D.target_position = $demo_player.position
#	print($demo_player/Camera3D/RayCast3D.get_collider())
#	if $demo_player/Camera3D/RayCast3D.get_collider() != null:
#		$demo_player/Camera3D/RayCast3D.get_collider().visible = false

	
	#var query = PhysicsRayQueryParameters3D.create($demo_player/Camera3D.project, $demo_player.position)
	#query.collide_with_areas = true
	#query.collision_mask = 0b10000000_00000000_00000000_00001000
	#var collision = get_world_3d().direct_space_state.intersect_ray(query)
	#if (collision):
#		collision.get("collider").get_parent().visible = false

#	if Input.is_action_just_released("T"):
#		if better_lightning == true:
#			better_lightning = !better_lightning
#			$WorldEnvironment.environment.set_ssil_enabled(better_lightning)
#			#$WorldEnvironment.environment.set_sdfgi_enabled(better_lightning)
#			$Control/VBoxContainer/Label4.text = "Toggle SSIL: T (OFF)"
#		else:
#			better_lightning = !better_lightning
#			$WorldEnvironment.environment.set_ssil_enabled(better_lightning)
#			#$WorldEnvironment.environment.set_sdfgi_enabled(better_lightning)
#			$Control/VBoxContainer/Label4.text = "Toggle SSIL: T (ON)"
#
#	if Input.is_action_just_released("Q"):
#		if !iso:
#			$demo_player/Camera3D.current = false
#			$demo_player/Camera3D_ISO.current = true
#			iso = !iso
#		else:
#			$demo_player/Camera3D.current = true
#			$demo_player/Camera3D_ISO.current = false
#			iso = !iso


func _on_area_3d_area_entered(area):
	print("entered")
	area.get_parent().set_transparency(0.8)
	#area.get_parent().get_node("AnimationPlayer").play("fadeOut");


func _on_area_3d_area_exited(area):
	print("exited")
	area.get_parent().set_transparency(0)
	#area.get_parent().get_node("AnimationPlayer").play("fadeIn");
