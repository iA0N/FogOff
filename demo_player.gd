extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 10
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75


var movement_speed: float = 4.0
var movement_target_position: Vector3 = Vector3(50, 0, 50)

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

var target_velocity = Vector3.ZERO

func _ready():
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5
	call_deferred("actor_setup")
	
func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		return

	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()

	var new_velocity: Vector3 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized()
	new_velocity = new_velocity * movement_speed

	velocity = new_velocity
	move_and_slide()
	return

	
	var direction = Vector3.ZERO
	var moving = false
	speed = 6
	if Input.is_action_pressed("D"):
		direction.x += 1
	if Input.is_action_pressed("A"):
		direction.x -= 1
	if Input.is_action_pressed("S"):
		direction.z += 1
	if Input.is_action_pressed("W"):
		direction.z -= 1

	if direction.x != 0 || direction.z != 0:
		moving = true
	
	$Marker3D.position = $ChrKnight.position
	$Marker3D.position.x += 0.01
	if (direction.x != 0 || direction.z != 0):
		$ChrKnight.look_at(Vector3($Marker3D.global_position.x - direction.x * 10, 0, $Marker3D.global_position.z - direction.z * 10))


	if direction.x != 0 && direction.z != 0:
		speed = 4
	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	# Moving the Character
	velocity = target_velocity
	move_and_slide()
	self.position.y = 0
	
	if moving:
		$AnimationPlayer.play("jump")
	else:
		$AnimationPlayer.stop()
		$ChrKnight.position.y = 0





func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(movement_target_position)

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)
