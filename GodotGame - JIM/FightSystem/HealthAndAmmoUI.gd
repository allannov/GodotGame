extends Control

onready var label = $AmmoUI
onready var hearts = $HeartUI
onready var player = owner

func _ready():
	label.text = "10"
	player.connect("ammo_changed", self, "set_ammo")
	player.connect("health_changed", self, "set_heart")

func set_ammo(ammo_amount):
	label.text = str(ammo_amount)
	
func set_heart(health_amount):
	hearts.rect_size.x = health_amount * 16
