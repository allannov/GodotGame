extends KinematicBody2D
# HeartBeast YouTube video - Make an Action RPG in Godot 3.2

const ACCELERATION = 900
const MAX_SPEED = 250
const FRICTION = 1500
const BULLET_SPEED = 1000

var bullet = preload("res://FightSystem/Bullet.tscn")
var bullet_amount = 100
var velocity = Vector2.ZERO
var hittable = false

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
	#print(velocity) # debug in output
	velocity = move_and_slide(velocity) # velocity relative to delta automatically
	
	# shooting mechanic
	if Input.is_action_just_pressed("LMB") and (bullet_amount >= 1):
		fire_bullet()
		if bullet_amount > 0:
			bullet_amount -= 1

# creating a bullet when fired
func fire_bullet():
	var bullet_instance = bullet.instance()
	bullet_instance.position = get_global_position()
	bullet_instance.apply_impulse(Vector2(), Vector2(BULLET_SPEED, 0).rotated(rotation))
	get_tree().get_root().call_deferred("add_child", bullet_instance)
