extends Node2D

const STEPS_AMOUNT = 10_000

var borders = Rect2(1, 1, 66, 34)

onready var tileMap = $WallTileMap

func _ready():
	randomize()
	generate_level()
	
func generate_level():
	var walker = Walker.new(Vector2(33, 17), borders)
	var map = walker.walk(STEPS_AMOUNT) # steps, can be tweaked
	walker.queue_free()
	for location in map:
		tileMap.set_cellv(location, -1)
	tileMap.update_bitmask_region(borders.position, borders.end)
