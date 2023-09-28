extends Node3D

var mouse_sens = 1.0
var cam = Vector2.ZERO
var d: float = 4.0

func _ready():
	d = $Camera3D.position.z

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		if event.button_mask == 1:
			cam += event.relative * mouse_sens / 180
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			d += 0.1
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			d -= 0.1
	update_camera()

func update_camera():
	set_identity()
	rotate_x(cam.y)
	rotate_y(cam.x)
	$Camera3D.position.z = d
