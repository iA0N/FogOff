extends Node3D

var better_lightning = true
var iso = false
@onready var env = $WorldEnvironment.environment
var target = null;
func _ready():
	print("test")
	# ssil
	# sdfgi

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
