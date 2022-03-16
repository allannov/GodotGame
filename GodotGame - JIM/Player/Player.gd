extends KinematicBody2D
# HeartBeast YouTube video - Make an Action RPG in Godot 3.2

const ACCELERATION = 600
const MAX_SPEED = 200
const FRICTION = 700

var velocity = Vector2.ZERO

func _physics_process(delta): # if something changes over time, multiply with delta
	var input_vector = Vector2.ZERO
	
	# movement input
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized() # diagonal movement is same speed as straight
	
	# check if no input for standing still
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	# applying velocity to movement
	print(velocity) # debug in output
	velocity = move_and_slide(velocity) # velocity relative to delta automatically
