extends KinematicBody2D

const ACCELERATION = 5000
const KNOCKBACK = 80
const MAX_SPEED = 190
const FRICTION = 1500

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var player = null
var hp = 1 + LevelVariables.enemy_hardness

var moved_right = true

signal enemy_dead

onready var animationPlayer = get_node("AnimationPlayer")

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)
	
	if player: # enemy movement toward player
		velocity = position.direction_to(player.position)
		velocity = velocity.move_toward(velocity * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
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
		#velocity = velocity.move_toward(velocity * MAX_SPEED, ACCELERATION * delta)
	else:
		animationPlayer.play("Idle")
	
	velocity = move_and_slide(velocity)
	

func _on_HurtBox_area_entered(area):
	knockback = area.knockback_vector * KNOCKBACK
	hp -= 1
	if hp == 0:
		emit_signal("enemy_dead", position)
		queue_free()


func _on_PlayerDetection_body_entered(body):
	player = body


func _on_PlayerDetection_body_exited(body):
	player = null
