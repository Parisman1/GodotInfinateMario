extends Node
class_name Generator

var model = LevelModel.new()

enum STATE {Ground, Gap}

var position = Vector2.ZERO
var direction = Vector2.UP
var borders = Rect2()
var step_history = []
var steps_since_turn = 0
var previous_direction = Vector2.ZERO

var Gap_chance = false
var Hill_change_chance = false
var Ground_list = []
var State = STATE.Ground
var Hill_height = 4
var Base_height = 2
var Gap_width = 3
var temp_gap = 0
var temp_height = 1
var temp_hill = 0
var hill_width = 2

var MAX_Width = 5
var MAX_Height = 3
#10 width w/ height 3 is the max
#normal height max is 4

#--name: _init()
# paramaters: starting_pos: Vector2
#			  new_border: Rect2
#			  player: Player Scene
# return: NA
# description:
#	checks that starting position is in border, appends the list of 
#	positions with starting pos and sets border as the new border
func _init(starting_pos, new_border, _player):
	randomize()
	assert(new_border.has_point(starting_pos))
	position = starting_pos
	step_history.append(position)
	Ground_list.append(0)
	borders = new_border
	model = LevelModel.new()

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
			if direction == Vector2.UP:
				temp_height +=1
			if direction == Vector2.DOWN:
				temp_height -=1
			
			if State == STATE.Gap:
				Ground_list.append(-1)
				
			elif State == STATE.Ground and temp_height <= Hill_height:
				#print("Hill Height: ", Hill_height)
				Ground_list.append(0)
				
			else:
				Ground_list.append(-1)
				
			step_history.append(position)
		else:
			change_direction()
			
		if temp_gap > Gap_width:
			temp_gap = 0
			normalize_state()
			
	return [step_history, Ground_list]

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
		
		if State == STATE.Ground:
			chance()
			
		if State == STATE.Gap: 
			temp_gap += 1
			
		elif State == STATE.Ground:
			temp_hill += 1
			
		previous_direction = direction
		direction = Vector2.RIGHT

	elif direction == Vector2.DOWN:
		
		if State == STATE.Ground:
			chance()
			
		if State == STATE.Gap: 
			temp_gap += 1
			
		elif State == STATE.Ground:
			temp_hill += 1
			
		previous_direction = direction
		direction = Vector2.RIGHT

	elif direction == Vector2.RIGHT and previous_direction == Vector2.UP:
		temp_height = 13
		direction = Vector2.DOWN

	elif direction == Vector2.RIGHT and previous_direction == Vector2.DOWN:
		temp_height = 1
		direction = Vector2.UP

func chance():
	var dice = randi() % 10 + 1
	
	match dice:
		1: # change to gap
			#print("current gap count: ", model.CurrentGapCount())
			#print("Max Gap: ", model.GetMaxGapCount())
			if temp_hill > hill_width and model.CurrentGapCount() < model.GetMaxGapCount():
				#print("in")
				model.MaxGroundWidth(temp_hill)
				temp_hill = 0
				State = STATE.Gap
				model.GapNumber()
				Decide_Gap_Distance()
		
		2: # change hill height
			Decide_Hill_Height()
			
		_: # base case, ground
			State = STATE.Ground

func normalize_state():
	State = STATE.Ground

func Decide_Gap_Distance():
	Gap_width = randi() % MAX_Width + 1
	model.MaxGapWidth(Gap_width)
	
func Decide_Hill_Height():
	var porm = randi() % 2
	if porm == 1 or porm == 2:
		Hill_height += randi() % MAX_Height + 1
	else:
		Hill_height -= randi() % 2 + 1
		
	if Hill_height < Base_height:
		Hill_height = Base_height

func getModel():
	return model
