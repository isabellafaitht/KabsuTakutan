extends KinematicBody

export var moveSpeed: float = 7.0
export var jumpForce: float = 10.0
export var gravity: float = 12.0

var minLookAngle: float = -90.0
var maxLookAngle: float = 90.0
var lookSensitivity: float = 0.5

var velocity: Vector3 = Vector3()
var mouseDelta: Vector2 = Vector2()

onready var camera = get_node("Camera")

func _input(event):
	if event is InputEventMouseMotion:
		mouseDelta = event.relative

func _process(delta):
	camera.rotation_degrees -= Vector3(rad2deg(mouseDelta.y),0,0) * lookSensitivity*delta
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, minLookAngle, maxLookAngle)
	rotation_degrees -= Vector3(0, rad2deg(mouseDelta.x), 0) * lookSensitivity*delta
	
	mouseDelta = Vector2()

func _physics_process(delta):
	velocity.x = 0
	velocity.z = 0
	var input = Vector2()
	
	if Input.is_action_pressed("move_forward"):
		input.y -= 1
	if Input.is_action_pressed("move_backward"):
		input.y += 1
	if Input.is_action_pressed("move_left"):
		input.x -= 1
	if Input.is_action_pressed("move_right"):
		input.x += 1
	
	input = input.normalized()
	
	var forward = global_transform.basis.z
	var right = global_transform.basis.x
	
	velocity.z = (forward*input.y + right * input.x).z*moveSpeed
	velocity.x = (forward*input.y + right * input.x).x*moveSpeed
	
	velocity.y -= gravity*delta
	velocity = move_and_slide(velocity, Vector3.UP)
	
	if Input.is_action_just_pressed("jump"):
		velocity.y = jumpForce
		
	
	if Input.is_action_just_pressed("Flashlight"):
		visible = !visible

func window_activity():
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	OS.window_fullscreen = true
