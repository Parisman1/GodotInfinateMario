extends Node
class_name Generator

var empty = []

onready var model = LevelModel.new(empty)

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
var previousColHeight = 4

var hill_width = 2

var MAX_Width = 5
var MIN_Width = 1

var MAX_Height = 3
var MIN_Height = 1

const GAME_HEIGHT = 13
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
func _init(starting_pos, new_border, _player, paramaters):
	randomize()
	assert(new_border.has_point(starting_pos))
	position = starting_pos
	step_history.append(position)
	Ground_list.append(0)
	borders = new_border
	model = LevelModel.new(paramaters)
	AlterGen()

func AlterGen():
	#MAX_Height = model.maxHeight
	MIN_Height = model.minChangeInHeight
	MAX_Width = model.maxWidthOfGap
	if MAX_Width <= 0:
		MAX_Width = 1
	MIN_Width = model.minWidthOfGap
	Hill_height = model.lastHeightofPreviousChunk

#--name: walk()
# paramaters: steps: int
# return: step_history: list of positions
# description:
#	"walks" through each step, changing direction when necesarry
#	and recording every valid step to be used by the tilemap
func walk():
	while CheckBounds():
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

func CheckBounds():
	if direction == Vector2.RIGHT:
		var target_pos = position + direction
		if borders.has_point(target_pos):
			return true
		return false
	else:
		return true

#--name: change_direction()
# paramaters: NA
# return: NA
# description:
#	changes direction based on previous direction, resets steps counter
func change_direction():
	steps_since_turn = 0

	if direction == Vector2.UP:
		Check_State()

	elif direction == Vector2.DOWN:
		Check_State()

	elif direction == Vector2.RIGHT and previous_direction == Vector2.UP:
		temp_height = 13
		direction = Vector2.DOWN

	elif direction == Vector2.RIGHT and previous_direction == Vector2.DOWN:
		temp_height = 1
		direction = Vector2.UP

func Check_State():
	if State == STATE.Ground:
		temp_hill += 1
		chance()
			
	if State == STATE.Gap: 
		temp_gap += 1
	
	model.lastHeightofPreviousChunk = Hill_height
	previous_direction = direction
	direction = Vector2.RIGHT

func chance():
	var dice = randi() % 10 + 1
	
	match dice:
		1: # change to gap
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
	Gap_width = randi() % MAX_Width + MIN_Width
	model.MaxGapWidth(Gap_width)
	
func Decide_Hill_Height():
	var porm = randi() % 2 + 1
	if porm == 1:
		#print("MAX_H: ", MAX_Height)
		#print("MIN_H: ", MIN_Height)
		var hill_inc = randi() % (MAX_Height-1) + (MIN_Height - 1)
		if hill_inc > 3:
			hill_inc = 3
		#print("hill_inc: ", hill_inc)
		Hill_height += hill_inc
		#print("HillHeight after inc: ", Hill_height)
		
	else:
		Hill_height -= randi() % MAX_Height + MIN_Height
		
	if Hill_height < Base_height:
		Hill_height = Base_height
		
	#print("Hill Height: ", Hill_height)
	if Hill_height > model.maxHeightReached:
		model.maxHeightReached = Hill_height
	if Hill_height > GAME_HEIGHT:
		Hill_height = GAME_HEIGHT
		#print("Hill after higher than game height: ", Hill_height)


func getModel():
	return model
