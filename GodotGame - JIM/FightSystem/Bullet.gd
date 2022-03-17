extends RigidBody2D

var time = 0
var hittable = false

func _ready():
	#warning-ignore:return_value_discarded
	connect("body_entered", self, "_on_character_body_entered")
	#look_at(get_global_mouse_position())

func _process(delta):
	time += delta
	#print("Time: %d" % time)
	if time >= 2:
		queue_free()
	
func _on_character_body_entered(body):
	if body.hittable == true:
		queue_free()
