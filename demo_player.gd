extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 10
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75

var last_position = self.position


var movement_speed: float = 4.0
var movement_target_position: Vector3 = Vector3(50, 0, 50)

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D2

var target_velocity = Vector3.ZERO

func _ready():
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5
	call_deferred("actor_setup")
	
func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		$AnimationPlayer.stop()
		return

	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var new_velocity: Vector3 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized()
	new_velocity = new_velocity * movement_speed

	$ChrKnight.look_at(next_path_position)
	$ChrKnight.rotation_degrees.y += 180
	$ChrKnight.rotation_degrees.x = 0
	$ChrKnight.rotation_degrees.z = 0
	$AnimationPlayer.play("jump")
	
	velocity = new_velocity
	move_and_slide()
	return


func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(movement_target_position)


func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)


func _on_area_3d_body_entered(body):
	body.get_node("FramedMeshInstance").set_transparency(0.8)


func _on_area_3d_body_exited(body):
	body.get_node("FramedMeshInstance").set_transparency(0)
