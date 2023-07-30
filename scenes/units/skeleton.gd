extends CharacterBody3D


const movement_speed = 5.0
@onready var navigation_agent = $NavigationAgent3D

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		$AnimationPlayer.stop()
		return

	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var new_velocity: Vector3 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized()
	new_velocity = new_velocity * movement_speed

	$Mesh.look_at(next_path_position)
	$Mesh.rotation_degrees.y += 180
	$Mesh.rotation_degrees.x = 0
	$Mesh.rotation_degrees.z = 0
	
	velocity = new_velocity
	move_and_slide()
	return
