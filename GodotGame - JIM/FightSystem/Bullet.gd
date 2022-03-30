extends RigidBody2D

var time = 0
var hittable = false

func _ready():
	#warning-ignore:return_value_discarded
	connect("body_entered", self, "_on_Bullet_body_entered")

func _process(delta):
	time += delta
	#print("Time: %d" % time) # debug
	if time >= 1:
		queue_free()
	
func _on_Bullet_body_entered(body):
	if body.hittable == true:
		queue_free()
