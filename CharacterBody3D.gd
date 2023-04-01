extends CharacterBody3D


const SPEED := 64.0
const JUMP_VELOCITY := 4.5

var look_sensitivity = ProjectSettings.get_setting("player/look_sensitivity")
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var velocity_y := 0
@onready var camera:Camera3D = $Camera3D

func _physics_process(_delta: float) -> void:
	var input_vector := Vector2(
		Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	).normalized()
	velocity = input_vector.x * global_transform.basis.x + input_vector.y * global_transform.basis.z
	if is_on_floor():
		velocity_y = 0
	else:
		velocity_y -= gravity * _delta
	velocity.y = velocity_y
	move_and_slide()
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE
		
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * look_sensitivity)
		camera.rotate_x(-event.relative.y * look_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
