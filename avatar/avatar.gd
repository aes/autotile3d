extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 12

var mouseSensibility = 1.0/120
var mouse_relative_x = 0
var mouse_relative_y = 0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(_delta):
	if Input.is_action_pressed("Zoom"):
		$Camera3D.fov = 40
	else:
		$Camera3D.fov = 75

	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	var y = Input.get_axis("Down", "Up")	
	velocity.y = y * SPEED if y else move_toward(velocity.y, 0, SPEED)

	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()

	if Input.is_action_just_pressed("ui_accept"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * mouseSensibility
		$Camera3D.rotation.x -= event.relative.y * mouseSensibility
		$Camera3D.rotation.x = clamp($Camera3D.rotation.x, deg_to_rad(-90), deg_to_rad(90) )
		mouse_relative_x = clamp(event.relative.x, -50, 50)
		mouse_relative_y = clamp(event.relative.y, -50, 10)
