extends Node2D

const STEPS_AMOUNT = 10_000

const Player = preload("res://Player/Player.tscn")
const Exit = preload("res://Level/ExitDoor.tscn")


var borders = Rect2(1, 1, 66, 34)

onready var tileMap = $WallTileMap

func _ready():
	randomize()
	generate_level()
	
func generate_level():
	var walker = Walker.new(Vector2(33, 17), borders)
	var map = walker.walk(STEPS_AMOUNT) # steps, can be tweaked
	
	var player = Player.instance()
	add_child(player)
	player.position = map.front() * 16
	
	var exit = Exit.instance()
	add_child(exit)
	exit.position = walker.rooms.back().position * 16 # BETTER SPAWN IT ON LAST ENEMY DEATH POSITION
	exit.connect("leaving_level", self, "reload_level")
	
	walker.queue_free()
	for location in map:
		tileMap.set_cellv(location, -1)
	tileMap.update_bitmask_region(borders.position, borders.end)
	
func reload_level():
	get_tree().reload_current_scene() # invoke this function when last enemy on the level dies and the player touches the exit
	
func _input(event):
	if event.is_action_pressed("T"):
		reload_level()
