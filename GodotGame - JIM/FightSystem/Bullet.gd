extends RigidBody2D

var time = 0

func _ready():
	#warning-ignore:return_value_discarded
	connect("body_entered", self, "_on_Bullet_body_entered")

func _process(delta):
	time += delta
	#print("Time: %d" % time) # debug
	if time >= 1:
		queue_free()
	#yield(get_tree().create_timer(0.6), "timeout")
	#queue_free()
	
func _on_Bullet_body_entered(_body):
	queue_free()
