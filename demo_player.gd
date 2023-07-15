extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 6
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75

var target_velocity = Vector3.ZERO


func _physics_process(delta):
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
