extends Node
# HeartBeast Random Level Generation on YouTube
class_name Walker

const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]
const STEPS = 6 # default = 4
const PERCENTAGE = 0.25 # default = 0.25

var position = Vector2.ZERO
var direction = Vector2.RIGHT
var borders = Rect2()
var step_history = []
var steps_since_turn = 0



func _init(starting_pos, new_borders):
	assert(new_borders.has_point(starting_pos))
	position = starting_pos
	step_history.append(position)
	borders = new_borders
	

func walk(steps):
	create_room(position)
	for step in steps:
		if randf() <= PERCENTAGE or steps_since_turn >= STEPS: # tweak numbers for different result
			change_direction()
			
			if step():
				step_history.append(position)
			else:
				change_direction()
	return step_history
	
	
# take a single step
func step():
	var target_pos = position + direction
	if borders.has_point(target_pos):
		steps_since_turn += 1
		position = target_pos
		return true
	else:
		return false
		
func change_direction():
	create_room(position)
	steps_since_turn = 0
	var directions = DIRECTIONS.duplicate()
	directions.erase(direction)
	directions.shuffle()
	direction = directions.pop_front()
	while not borders.has_point(position + direction):
		direction = directions.pop_front()

func create_room(position): # new added feature for cleaner level generation
	var size = Vector2(randi() % 4 + 2, randi() % 4 + 2)
	var top_left_corner = (position - size / 2).ceil()
	for y in size.y:
		for x in size.x:
			var new_step = top_left_corner + Vector2(x, y)
			if borders.has_point(new_step):
				step_history.append(new_step)
