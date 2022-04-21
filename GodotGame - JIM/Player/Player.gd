extends KinematicBody2D
# Main inspiration/help from HeartBeast YouTube video - Make an Action RPG in Godot 3.2


# constants
const ACCELERATION = 800
const KNOCKBACK = 10
const MAX_SPEED = 150
const FRICTION = 1500
const BULLET_SPEED = 300
const BULLET_SPAWN_DISTANCE = 30

# firing specific variables
var bullet = preload("res://FightSystem/Bullet.tscn")
var bullet_amount = 10
var fire_rate = 0.2 # items change fire_rate or spread MAKE THIS!!
var reload_time = 1.2
var hp = 3


var velocity = Vector2.ZERO

onready var animationPlayer = get_node("AnimationPlayer")
var cursor_reload = preload("res://Reload.png")
var cursor_default = preload("res://Crosshair64.png")

# bool variables
var can_fire = true
var is_reloading = false
var moved_right = true # animation specific



func _physics_process(delta): # if something changes over time, multiply with delta
	var input_vector = Vector2.ZERO
	
	# movement input
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized() # diagonal movement is same speed as straight
	#print(input_vector) # debug
	
	# check if no input for standing still and animation choice
	if input_vector != Vector2.ZERO:
		if input_vector.x > 0:
			moved_right = true
			get_node("Sprite").flip_h = false
			animationPlayer.play("RunRight")
		elif input_vector.x < 0:
			moved_right = false
			get_node("Sprite").flip_h = true
			animationPlayer.play("RunRight")
		else:
			if moved_right:
				get_node("Sprite").flip_h = false
			animationPlayer.play("RunRight")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationPlayer.play("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	# applying velocity to movement
	#print(velocity) # debug in output
	velocity = move_and_slide(velocity) # velocity relative to delta automatically
	
	# shooting mechanic
	if Input.is_action_just_pressed("LMB") and (bullet_amount >= 1) and can_fire:
		var distance = fire_bullet()
		
		# vector in opposite direction
		distance.x *= -1
		distance.y *= -1
		
		# knockback the player
		velocity = velocity.move_toward(distance * MAX_SPEED, ACCELERATION * KNOCKBACK * delta)
		velocity = move_and_slide(velocity)
		
		# decrease bullet amount
		#print("Before shot: {0}".format({0:bullet_amount})) # debug
		bullet_amount -= 1
		#print("After shot: {0}".format({0:bullet_amount})) # debug
		
		# fire rate
		can_fire = false
		yield(get_tree().create_timer(fire_rate), "timeout")
		can_fire = true
	
	# reload if pressed, otherwise reload when shot and empty 
	if Input.is_action_just_pressed("reload") or ((bullet_amount == 0) and Input.is_action_just_pressed("LMB")):
		if not is_reloading:
			reloading()


# creating a bullet when fired
func fire_bullet() -> Vector2:
	
	# create a bullet instance
	var bullet_instance = bullet.instance()
	
	# find vector between mouse and player
	var distance = get_global_mouse_position() - get_node("Position2D").get_global_position()
	distance = distance.normalized()
	#print("Distance vector: {0}".format({"0":distance})) # debug
	
	#print("Rotation of Player: {0}".format({"0":rotation})) # debug
	
	# spawn bullet from some distance relative to player
	bullet_instance.position = get_node("Position2D").get_global_position() + distance * BULLET_SPAWN_DISTANCE
	
	# rotate the sprite depending on vector
	bullet_instance.rotation = distance.angle()
	
	# bullet flies in the direction of the vector
	bullet_instance.apply_impulse(Vector2(), Vector2(BULLET_SPEED, 0).rotated(bullet_instance.rotation))
	
	bullet_instance.knockback_vector = distance.normalized() # for enemy knockback
	
	#get_tree().get_root().call_deferred("add_child", bullet_instance) # other way of adding child
	get_tree().get_root().add_child(bullet_instance)
	
	return distance


func reloading():
	is_reloading = true
	can_fire = false
	Input.set_custom_mouse_cursor(cursor_reload, Input.CURSOR_ARROW, Vector2(32, 32))
	#print("Reloading") # debug
	yield(get_tree().create_timer(reload_time), "timeout")
	#print("Reloaded") # debug
	Input.set_custom_mouse_cursor(cursor_default, Input.CURSOR_ARROW, Vector2(32, 32))
	is_reloading = false
	can_fire = true
	bullet_amount = 10


func _on_HurtBox_area_entered(_area):
	hp -= 1
	if hp == 0:
		queue_free()
		# emit a signal to inform game over screen
