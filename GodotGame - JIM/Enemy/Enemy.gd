extends KinematicBody2D

const ACCELERATION = 800
const KNOCKBACK = 10
const MAX_SPEED = 150
const FRICTION = 1500

var velocity = Vector2.ZERO
var player = null
var hp = 3

var moved_right = true

signal enemy_dead

onready var animationPlayer = get_node("AnimationPlayer")

func _physics_process(delta):
	velocity = Vector2.ZERO
	
	if player:
		velocity = position.direction_to(player.position)
	
	if velocity != Vector2.ZERO:
		if velocity.x > 0:
			moved_right = true
			get_node("Sprite").flip_h = false
			animationPlayer.play("RunRight")
		elif velocity.x < 0:
			moved_right = false
			get_node("Sprite").flip_h = true
			animationPlayer.play("RunRight")
		else:
			if moved_right:
				get_node("Sprite").flip_h = false
			animationPlayer.play("RunRight")
		velocity = velocity.move_toward(velocity * MAX_SPEED, ACCELERATION * delta)
	else:
		animationPlayer.play("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = move_and_slide(velocity)
	
#func _on_DetectionZone_body_entered(body):
	#player = body

#func _on_DetectionZone_body_exited(body): # maybe not lose player position
	#player = null

func _on_HurtBox_area_entered(_area):
	hp -= 1
	if hp == 0:
		emit_signal("enemy_dead", position)
		print(position)
		queue_free()
