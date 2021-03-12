extends Node
class_name LevelModel

var MAX_WIDTH = 9
var MAX_HEIGHT = 3

var numberOfGaps = 0
var numberOfPlatforms = 0
var numberOfEnemies = 0
var maxNumberOfGapsAllowed = 3
var maxNumberOfEnemies = 0
var minChangeInHeight = 0
var maxHeight = 4
var minWidthOfGap = 1
var maxWidthOfGap = 1
var previousGroundWidth = 0

var MAX_altering_number = 3
var MIN_altering_number = 1

var Paramaters = []

func _init(paramaters):
	randomize()
	if len(paramaters) == 0:
		numberOfGaps = 0
		numberOfPlatforms = 0
		numberOfEnemies = 0
		maxNumberOfGapsAllowed = 3
		maxNumberOfEnemies = 0
		minChangeInHeight = 1
		maxHeight = 3
		minWidthOfGap = 1
		maxWidthOfGap = 5
		previousGroundWidth = 0
	else:
		numberOfGaps = 0
		numberOfPlatforms = paramaters[1]
		numberOfEnemies = paramaters[2]
		maxNumberOfGapsAllowed = paramaters[3]
		maxNumberOfEnemies = paramaters[4]
		minChangeInHeight = paramaters[5]
		maxHeight = 4
		minWidthOfGap = paramaters[6]
		maxWidthOfGap = paramaters[7]
		previousGroundWidth = 0

func GapNumber():
	numberOfGaps += 1

func GetMaxGapCount():
	return maxNumberOfGapsAllowed

func CurrentGapCount():
	return numberOfGaps

func PlatformNumber():
	numberOfPlatforms +=1

func EnemyNumber():
	numberOfEnemies += 1

func MaxGapWidth(width):
	if width > maxWidthOfGap:
		maxWidthOfGap = width

func MaxGroundWidth(width):
	if width > previousGroundWidth:
		previousGroundWidth = width

func Print():
	print("====================")
	print("number of gaps: ", numberOfGaps)
	print("number of platforms: ", numberOfPlatforms)
	print("number of enemies: ", numberOfEnemies)
	print("max number of gaps per: ", maxNumberOfGapsAllowed)
	print("max number of enemies: ", maxNumberOfEnemies)
	print("min change in height: ", minChangeInHeight)
	print("max change in height: ", maxHeight)
	print("min width of gap: ", minWidthOfGap)
	print("max width of gap: ", maxWidthOfGap)
	print("max ground width ", previousGroundWidth)
	print("====================")
	
func Construct():
	Paramaters = [
	numberOfGaps,           # 0 counter for gaps
	numberOfPlatforms,      #@ 1 less platforms is more hard
	numberOfEnemies,        # 2 counter for enemoes
	maxNumberOfGapsAllowed, #@ 3 more gaps is more hard
	maxNumberOfEnemies,     #@ 4 more enemies is more hard
	minChangeInHeight,      #@ 5 higher base change is more hard
	minWidthOfGap,          #@ 6 larger min gap is hard
	maxWidthOfGap,          #@ 7 larger max gap is hard
	previousGroundWidth     # 8 documents width of ground
	]


#TO DO GENETIC FUCKING SHIT, TAKE THE PARAMATER LIST, GENERATE A BLOCK, CHECK THE DIFF, IF DIFF NOT HIGHER OR LOWER BASED
#ON SKILL OF PLAYER, DO IT AGAIN, UP TO 3 TIMES AND TAKE THE BEST ONE I SUPPOSE, SHIT WILL TAKE YEARS SO WILL HAVE
#TO TWEAK FINALLY FITNESS FUNCTION WILL MAYBE BE USED

#GENERATE CHUNK WITH CHANGED PARAMATERS UNTILL THE DIFF AND PERSIEVED_DIFFICULTY IS WITHIN A SMALL DIFFERENCE
#func IncreaseDiff() and inside make *random* changes toward making it more difficult
#func DecreaseDiff() and inside make *random* changes toward making it less difficult

func IncreaseDiff():
	var dice = randi() % 8
	match dice:
		0:
			dice = 3
		1:
			dice = 7
		2:
			dice = 5
		8:
			dice = 6
			
	print("increase dice: ")
	match dice:
		0:
			pass
		1:
			pass
		2:
			pass
		3:
			maxNumberOfGapsAllowed = maxNumberOfGapsAllowed + randi() % MAX_altering_number + MIN_altering_number
		4:
			maxNumberOfEnemies = maxNumberOfEnemies + randi() % MAX_altering_number + MIN_altering_number
		5:
			minChangeInHeight = minChangeInHeight + randi() % MAX_altering_number + MIN_altering_number
			if minChangeInHeight > MAX_HEIGHT:
				minChangeInHeight = MAX_HEIGHT
		6:
			minWidthOfGap = minWidthOfGap + randi() % MAX_altering_number + MIN_altering_number
			if minWidthOfGap > MAX_WIDTH:
				minWidthOfGap = MAX_WIDTH
		7:
			maxWidthOfGap = maxWidthOfGap + randi() % MAX_altering_number + MIN_altering_number
		8:
			pass
	

func DecreaseDiff():
	var dice = randi() % 8
	match dice:
		0:
			dice = 3
		1:
			dice = 7
		2:
			dice = 5
		8:
			dice = 6
			
	print("decrease dice: ")
	match dice:
		0:
			pass
		1:
			pass
		2:
			pass
		3:
			maxNumberOfGapsAllowed = maxNumberOfGapsAllowed - randi() % MAX_altering_number + MIN_altering_number
		4:
			maxNumberOfEnemies = maxNumberOfEnemies - randi() % MAX_altering_number + MIN_altering_number
		5:
			minChangeInHeight = minChangeInHeight - randi() % MAX_altering_number + MIN_altering_number
			if minChangeInHeight > MAX_HEIGHT:
				minChangeInHeight = 3
		6:
			minWidthOfGap = minWidthOfGap - randi() % MAX_altering_number + MIN_altering_number
			if minWidthOfGap < 0:
				minWidthOfGap = 0
		7:
			maxWidthOfGap = maxWidthOfGap - randi() % MAX_altering_number + MIN_altering_number
			if maxWidthOfGap < 0:
				maxWidthOfGap = 0
		8:
			pass

func GetParamaters():
	return [
	numberOfGaps,           # 0 counter for gaps
	numberOfPlatforms,      #@ 1 less platforms is more hard
	numberOfEnemies,        # 2 counter for enemoes
	maxNumberOfGapsAllowed, #@ 3 more gaps is more hard
	maxNumberOfEnemies,     #@ 4 more enemies is more hard
	minChangeInHeight,      #@ 5 higher base change is more hard
	minWidthOfGap,          #@ 6 larger min gap is hard
	maxWidthOfGap,          #@ 7 larger max gap is hard
	previousGroundWidth     # 8 documents width of ground
	]

func GetDiff():
	Construct()
#	print("=====")
#	print(Paramaters)
#	print("=====")
	var difficulty = 0
	for param in Paramaters:
		difficulty += float(GetWeight(float(param), float(len(Paramaters)))) * float(param)
	return difficulty

func GetWeight(param, size):
	if param == 0:
		return 0
	else:
		return float(1/(size * param))
