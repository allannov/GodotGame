extends Node
func _ready():
	var rand = RandomNumberGenerator.new()
	var enemyvis = load("res://Enemy/Enemy.tscn")
	#for loop will be when we have more difficult
	var enemy = enemyvis.instance()
	#conditions for not spawning on hero or walls when we have level generation
	rand.randomize()
	var x = rand.randf_range(32, 288)
	rand.randomize()
	var y = rand.randf_range(32, 158)
	enemy.position.y = y
	enemy.position.x = x
	add_child(enemy)
