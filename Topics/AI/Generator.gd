extends Node
class_name Generator

const DIRECTIONS = [Vector2.UP, Vector2.RIGHT, Vector2.LEFT, Vector2.DOWN]

var position = Vector2.ZERO
var direction = Vector2.DOWN
var borders = Rect2()
var step_history = []
var steps_since_turn = 0
var previous_direction = Vector2.ZERO

func _ready():
	pass

func _init(starting_pos, new_border, player):
	#player = get_node("Player")
	#player.connect("player", self, "Get_Player")
	assert(new_border.has_point(starting_pos))
	position = starting_pos
	step_history.append(position)
	borders = new_border
	

func walk(steps):
	for step in steps:
		if direction == Vector2.RIGHT and steps_since_turn == 1:
			#print("bruh")
			change_direction()
		if step():
			#print("bruh2")
			step_history.append(position)
		else:
			change_direction()
		#print("step size: ", step_history.size())
		#print("steps since: ", steps_since_turn)
	return step_history
	
func step():
	var target_pos = position + direction
	if borders.has_point(target_pos):
		steps_since_turn += 1
		position = target_pos
		return true
	else: return false
	
func change_direction():
	steps_since_turn = 0

	if direction == Vector2.UP:
		#print("up to right")
		previous_direction = direction
		direction = Vector2.RIGHT

	elif direction == Vector2.DOWN:
		#print("down to right")
		previous_direction = direction
		direction = Vector2.RIGHT

	elif direction == Vector2.RIGHT and previous_direction == Vector2.UP:
		#print("right to down")
		direction = Vector2.DOWN

	elif direction == Vector2.RIGHT and previous_direction == Vector2.DOWN:
		#print("right to up")
		direction = Vector2.UP
		
	


#func Get_Player(Player):
#	print("Got Signal")
#	player = Player


