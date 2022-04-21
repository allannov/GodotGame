extends KinematicBody2D

var run_speed = 25
var velocity = Vector2.ZERO
var player = null

func _physics_process(delta):
	velocity = Vector2.ZERO
	if player:
		velocity = position.direction_to(player.position) * run_speed
	velocity = move_and_slide(velocity)

var hittable = false

func _on_DetectionZone_body_entered(body):
	player = body


func _on_DetectionZone_body_exited(body):
	player = null



func _on_Hurt_area_entered(area):
	queue_free()

