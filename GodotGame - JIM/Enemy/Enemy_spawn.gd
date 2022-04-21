extends Node

func _ready():
	var rand = RandomNumberGenerator.new()
	var enemyvis = load("res://Enemy/Enemy.tscn")
	
	#while or for loop for difficulty increase
	var enemy = enemyvis.instance()
	var reborn = 0
	if reborn > 0:
		rand.randomize()
		var x = rand.randf_range(32, 288)
		rand.randomize()
		var y = rand.randf_range(32, 158)
		enemy.position.y = y
		enemy.position.x = x
		add_child(enemy)
		#condition not to spawn on walls and player --> reborn++
	else:
		rand.randomize()
		var x = rand.randf_range(32, 288)
		rand.randomize()
		var y = rand.randf_range(32, 158)
		enemy.position.y = y
		enemy.position.x = x
		add_child(enemy)
