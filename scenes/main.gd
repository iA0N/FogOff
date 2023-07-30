extends Node3D

var better_lightning = true
var iso = false
@onready var env = $WorldEnvironment.environment
@onready var chunk_scene = load("res://scenes/chunk.tscn")
var tree_rids = []
var done = false

var thread1: Thread
var thread2: Thread
var chunks = []
var mutex: Mutex

var init_done = false

func _ready():
	thread1 = Thread.new()
	thread2 = Thread.new()
	mutex = Mutex.new()
	
	#thread1.start(_instantiateChunks.bind(0))
	#thread2.start(_instantiateChunks.bind(5))
	#thread1.wait_to_finish()
	#thread2.wait_to_finish()
	
	for i in 10:
		for j in 10:
			var chunk_instance = chunk_scene.instantiate()
			chunk_instance.position = Vector3((8 + i * 16), 0, (8 + j * 16))
			chunks.append(chunk_instance)
			if chunks.size() % 10 == 0:
				print("Status: " + str(chunks.size()) + " / 100") 
			
	for i in range (0, chunks.size()):
		print("Adding chunkg: " + str(i))
		add_child(chunks[i])
		#if true:#chunks[i].position.distance_to($demo_player.position) < 40:
			#chunks[i].visible = true
			#chunks[i].get_node("NavigationRegion3D").enabled = true
			#await get_tree().create_timer(2).timeout

	while(true):
		var all_done = true
		for chunk in chunks:
			if chunk.init_done == false:
				all_done = false
				break
		await get_tree().physics_frame
		await get_tree().physics_frame
		await get_tree().physics_frame
		if all_done:
			break

	$Control.get_node("ColorRect").visible = false
	$Control.get_node("Label").visible = false
	
	var player_scene = load("res://scenes/demo_player.tscn")
	var player_instance = player_scene.instantiate()
	add_child(player_instance)
	player_instance.position = Vector3(50,1,50)
	init_done = true
	#var default_3d_map_rid: RID = get_world_3d().get_navigation_map()
	#NavigationServer3D.map_set_edge_connection_margin(default_3d_map_rid, 1.2)

var LMB_pressed = false

func _input(event):
	if init_done:
		if event is InputEventMouseButton and Input.is_action_just_pressed("LBM"):
			LMB_pressed = true
		
		if event is InputEventMouseButton and Input.is_action_just_released("LBM"):
			LMB_pressed = false
			
		if LMB_pressed:
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
			print("Main | Clicked to move at: " + str(result))
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


func _instantiateChunks(start):
	print("started from " + str(start))
	for i in range(start, start+5):
		for j in 10:
			mutex.lock()
			var chunk_instance = chunk_scene.instantiate()
			chunk_instance.position = Vector3((8 + i * 16), 0, (8 + j * 16))
			chunks.append(chunk_instance)
			if chunks.size() % 10 == 0:
				print("Status: " + str(chunks.size()) + " / 10000") 
			mutex.unlock()
				
