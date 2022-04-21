extends Node2D

const STEPS_AMOUNT = 10_000

const Player = preload("res://Player/Player.tscn")
const Enemy = preload("res://Enemy/Enemy.tscn")
const Exit = preload("res://Level/ExitDoor.tscn")

var borders = Rect2(1, 1, 66, 34)

onready var tileMap = $WallTileMap

var enemy_amount

signal level_reload

func _ready():
	randomize()
	generate_level()
	
func generate_level():
	var walker = Walker.new(Vector2(33, 17), borders)
	var map = walker.walk(STEPS_AMOUNT) # steps, can be tweaked
	
	var player = Player.instance()
	add_child(player)
	player.position = map.front() * 16
	
	enemy_amount = 5
	for i in enemy_amount:
		spawn_enemy(walker)
	
	walker.queue_free()
	for location in map:
		tileMap.set_cellv(location, -1)
	tileMap.update_bitmask_region(borders.position, borders.end)
	
func spawn_enemy(walker):
	var enemy = Enemy.instance()
	var amount_of_rooms = walker.rooms.size()
	enemy.position = walker.rooms[amount_of_rooms - randi() % 500].position * 16
	get_tree().get_root().call_deferred("add_child", enemy)
	enemy.connect("enemy_dead", self, "lower_enemy_amount")
	
func lower_enemy_amount(last_pos):
	enemy_amount -= 1
	if enemy_amount == 0:
		spawn_exit(last_pos)
		
		
func spawn_exit(last_pos):
	var exit = Exit.instance()
	get_tree().get_root().call_deferred("add_child", exit)
	exit.position = last_pos # LAST ENEMY DEATH POSITION
	exit.position.x -= 10
	exit.position.y -= 10
	exit.connect("leaving_level", self, "reload_level")
	
func reload_level(body):
	body.queue_free()
	get_tree().reload_current_scene() # invoke this function when last enemy on the level dies and the player touches the exit
