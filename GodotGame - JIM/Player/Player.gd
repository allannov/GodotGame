extends KinematicBody2D
# HeartBeast YouTube video - Make an Action RPG in Godot 3.2

const ACCELERATION = 900
const MAX_SPEED = 250
const FRICTION = 1500
const BULLET_SPEED = 1000
const BULLET_SPAWN_DISTANCE = 45

var bullet = preload("res://FightSystem/Bullet.tscn")
var bullet_amount = 100 # have to reload MAKE THIS!!
var fire_rate = 0.2 # items change fire_rate or spread MAKE THIS!!
var can_fire = true

var velocity = Vector2.ZERO

onready var animationPlayer = get_node("AnimationPlayer")

var hittable = true

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
	if Input.is_action_just_pressed("LMB") and (bullet_amount >= 1) and can_fire:
		fire_bullet()
		if bullet_amount > 0:
			bullet_amount -= 1
		can_fire = false
		yield(get_tree().create_timer(fire_rate), "timeout")
		can_fire = true

# creating a bullet when fired
func fire_bullet():
	var bullet_instance = bullet.instance()
	
	var distance = get_global_mouse_position() - get_node("Position2D").get_global_position()
	distance = distance.normalized()
	#print("Distance vector: {0}".format({"0":distance})) # debug
	
	#print("Rotation of Player: {0}".format({"0":rotation})) # debug
	bullet_instance.position = get_node("Position2D").get_global_position() + distance * BULLET_SPAWN_DISTANCE
	
	bullet_instance.rotation = distance.angle()
	bullet_instance.apply_impulse(Vector2(), Vector2(BULLET_SPEED, 0).rotated(bullet_instance.rotation))
	
	#get_tree().get_root().call_deferred("add_child", bullet_instance) # other way of adding child
	get_tree().get_root().add_child(bullet_instance)
