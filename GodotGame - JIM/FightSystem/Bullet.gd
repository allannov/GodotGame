extends RigidBody2D

var time = 0
var knockback_vector = Vector2.ZERO

onready var Bullet_HitBox = $HitBox

func _ready():
	#warning-ignore:return_value_discarded
	Bullet_HitBox.knockback_vector = knockback_vector
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

func _on_HitBox_area_entered(_area):
	queue_free()
