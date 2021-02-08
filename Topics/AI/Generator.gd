extends Node
class_name Generator

const DIRECTIONS = [Vector2.UP, Vector2.RIGHT, Vector2.LEFT, Vector2.DOWN]

var position = Vector2.ZERO
var direction = Vector2.DOWN
var borders = Rect2()
var step_history = []
var steps_since_turn = 0
var previous_direction = Vector2.ZERO

#--name: _init()
# paramaters: starting_pos: Vector2
#			  new_border: Rect2
#			  player: Player Scene
# return: NA
# description:
#	checks that starting position is in border, appends the list of 
#	positions with starting pos and sets border as the new border
func _init(starting_pos, new_border, player):
	assert(new_border.has_point(starting_pos))
	position = starting_pos
	step_history.append(position)
	borders = new_border	

#--name: walk()
# paramaters: steps: int
# return: step_history: list of positions
# description:
#	"walks" through each step, changing direction when necesarry
#	and recording every valid step to be used by the tilemap
func walk(steps):
	for step in steps:
		if direction == Vector2.RIGHT and steps_since_turn == 1:
			change_direction()
		if step():
			step_history.append(position)
		else:
			change_direction()
	return step_history

#--name: step()
# paramaters: NA
# return: bool
# description:
#	checks if step is valid, if so sets the step as the current pos and returns
#	true, otherwise returns false
func step():
	var target_pos = position + direction
	if borders.has_point(target_pos):
		steps_since_turn += 1
		position = target_pos
		return true
	else: return false

#--name: change_direction()
# paramaters: NA
# return: NA
# description:
#	changes direction based on previous direction, resets steps counter
func change_direction():
	steps_since_turn = 0

	if direction == Vector2.UP:
		previous_direction = direction
		direction = Vector2.RIGHT

	elif direction == Vector2.DOWN:
		previous_direction = direction
		direction = Vector2.RIGHT

	elif direction == Vector2.RIGHT and previous_direction == Vector2.UP:
		direction = Vector2.DOWN

	elif direction == Vector2.RIGHT and previous_direction == Vector2.DOWN:
		direction = Vector2.UP
		
