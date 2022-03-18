extends KinematicBody2D
#сложно без созданных файлов по противникам
#only straight should do more natural or categorize behavior
#all stats will be asset when we have enemy classification
var run_speed = 25
var velocity = Vector2.ZERO
var player = null

func _physics_process(delta):
	velocity = Vector2.ZERO
	if player:
		velocity = position.direction_to(player.position) * run_speed
	velocity = move_and_slide(velocity)


func _on_detection_Zone_body_entered(body):
	player = body


func _on_detection_Zone_body_exited(body):
	player = null
