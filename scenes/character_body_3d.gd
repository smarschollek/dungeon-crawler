extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var camera = $Camera3D

enum ViewDirections { North, South, West, East }
var viewDirection: ViewDirections

func _physics_process(delta: float) -> void:
    # Add the gravity.
    if not is_on_floor():
        velocity += get_gravity() * delta

    # Handle jump.
    if Input.is_action_just_pressed("ui_accept") and is_on_floor():
        velocity.y = JUMP_VELOCITY

    #var input_dir := Input.get_vector("ui_up", "ui_down")
    
    rotate_camera()
    move()

func move():
    var direction = Vector3.ZERO
    
    if Input.is_action_pressed("ui_up"):
        direction += -camera.transform.basis.z
        
    if Input.is_action_pressed("ui_down"):
        direction += camera.transform.basis.z
        
    if direction.length() > 0:
        direction = direction.normalized()
        
    velocity = direction * SPEED
    move_and_slide()    
        
func rotate_camera():
    if Input.is_action_just_pressed("ui_left"):
        camera.rotate_y(deg_to_rad(90))
    elif Input.is_action_just_pressed("ui_right"):
        camera.rotate_y(-deg_to_rad(90))
        
    var forward_vector = -camera.transform.basis.z

    if abs(forward_vector.x) > abs(forward_vector.z):
        if forward_vector.x > 0:
            viewDirection = ViewDirections.West
        else:
            viewDirection = ViewDirections.East
    else:
        if forward_vector.z > 0:
            viewDirection = ViewDirections.South
        else:
            viewDirection = ViewDirections.North
