extends RigidBody2D

var time = 0

func _ready():
	connect("body_entered", self, "_on_character_body_entered")

func _process(delta):
	time += delta
	print("Time: %d" % time)
	if time >= 2:
		queue_free()
	
func _on_character_body_entered():
	queue_free()
