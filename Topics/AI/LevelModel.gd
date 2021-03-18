extends Node
class_name LevelModel

var MAX_WIDTH = 5
var MAX_HEIGHT = 3

var numberOfGaps = 0
var numberOfPlatforms = 0
var numberOfEnemies = 0
var maxNumberOfGapsAllowed = 3
var maxNumberOfEnemies = 1
var minChangeInHeight = 0
var maxHeightReached = 4
var minWidthOfGap = 1
var maxWidthOfGap = 1
var previousGroundWidth = 0
var lastHeightofPreviousChunk = 4

var MAX_altering_number = 3
var MIN_altering_number = 1

var Paramaters = []

func _init(paramaters:Array = []):
	randomize()
	if len(paramaters) == 0:
		numberOfGaps = 0
		numberOfPlatforms = 0
		numberOfEnemies = 0
		maxNumberOfGapsAllowed = 3
		maxNumberOfEnemies = 1
		minChangeInHeight = 1
		maxHeightReached = 4
		minWidthOfGap = 1
		maxWidthOfGap = 5
		previousGroundWidth = 0
		lastHeightofPreviousChunk = 4
	else:
		numberOfGaps = 0
		numberOfPlatforms = paramaters[1]
		numberOfEnemies = paramaters[2]
		maxNumberOfGapsAllowed = paramaters[3]
		maxNumberOfEnemies = paramaters[4]
		minChangeInHeight = paramaters[5]
		minChangeInHeight = CheckMinHeight(minChangeInHeight)
		maxHeightReached = paramaters[6]
		minWidthOfGap = paramaters[7]
		maxWidthOfGap = paramaters[8]
		previousGroundWidth = 0
		lastHeightofPreviousChunk = paramaters[10]

func CheckMinHeight(height):
	if height > MAX_HEIGHT:
		height = MAX_HEIGHT
	return height

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
	print("max change in height: ", maxHeightReached)
	print("min width of gap: ", minWidthOfGap)
	print("max width of gap: ", maxWidthOfGap)
	print("max ground width ", previousGroundWidth)
	print("lastHeightofPreviousChunk: ", lastHeightofPreviousChunk)
	print("====================")
	
func Construct():
	Paramaters = [
	numberOfGaps,             #  0 counter for gaps
	numberOfPlatforms,        #@ 1 less platforms is more hard
	numberOfEnemies,          #  2 counter for enemoes
	maxNumberOfGapsAllowed,   #@ 3 more gaps is more hard
	maxNumberOfEnemies,       #@ 4 more enemies is more hard
	minChangeInHeight,        #@ 5 higher base change is more hard
	maxHeightReached,         #  6 max height that got reached, documentation
	minWidthOfGap,            #@ 7 larger min gap is hard
	maxWidthOfGap,            #@ 8 larger max gap is hard
	previousGroundWidth,      #  9 documents width of ground
	lastHeightofPreviousChunk # 10 records the last height of the previous chunk
	]

func IncreaseDiff():
	var dice = randi() % 8
	
	# second chances are always welcome
	if minChangeInHeight == MAX_HEIGHT and dice == 5:
		dice = randi() % 8
		
	match dice:
		0:
			dice = 3
		1:
			dice = 7
		2:
			dice = 5
		8:
			dice = 6
			
	match dice:
		0:
			pass
		1:
			pass
		2:
			pass
		3:
			maxNumberOfGapsAllowed = maxNumberOfGapsAllowed + randi() % MAX_altering_number + MIN_altering_number
			#print("Max Number of gaps Increased to: ", maxNumberOfGapsAllowed)
		4:
			maxNumberOfEnemies = maxNumberOfEnemies + randi() % MAX_altering_number + MIN_altering_number
			#print("Max number of enemies Increased to :", maxNumberOfEnemies)
		5:
			minChangeInHeight = minChangeInHeight + randi() % MAX_altering_number + MIN_altering_number
			minChangeInHeight = CheckMinHeight(minChangeInHeight)
			#print("min Change in Height increased to: ", minChangeInHeight)
		6:
			minWidthOfGap = minWidthOfGap + randi() % MAX_altering_number + MIN_altering_number
			if minWidthOfGap > MAX_WIDTH:
				minWidthOfGap = MAX_WIDTH
			#print("min width of gap increased to: ", minWidthOfGap)
		7:
			maxWidthOfGap = maxWidthOfGap + randi() % MAX_altering_number + MIN_altering_number
			if maxWidthOfGap > MAX_WIDTH:
				maxWidthOfGap = MAX_WIDTH
			#print("max width of gap increased to: ", maxWidthOfGap)
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

	match dice:
		0:
			pass
		1:
			pass
		2:
			pass
		3:
			maxNumberOfGapsAllowed = maxNumberOfGapsAllowed - randi() % MAX_altering_number + MIN_altering_number
			#print("Max Number of gaps Decreased to: ", maxNumberOfGapsAllowed)
		4:
			maxNumberOfEnemies = maxNumberOfEnemies - randi() % MAX_altering_number + MIN_altering_number
			#print("Max number of enemies Decreased  to :", maxNumberOfEnemies)
		5:
			minChangeInHeight = minChangeInHeight - randi() % MAX_altering_number + MIN_altering_number
			if minChangeInHeight < 1:
				minChangeInHeight = 1
				#print("min Change in Height decreased to: ", minChangeInHeight)
		6:
			minWidthOfGap = minWidthOfGap - randi() % MAX_altering_number + MIN_altering_number
			if minWidthOfGap <= 0:
				minWidthOfGap = 1
				#print("min width of gap increased to: ", minWidthOfGap)
		7:
			maxWidthOfGap = maxWidthOfGap - randi() % MAX_altering_number + MIN_altering_number
			if maxWidthOfGap <= 0:
				maxWidthOfGap = 1
			#print("max width of gap decreased to: ", maxWidthOfGap)
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
	maxHeightReached,       #  6 documentor for height reached
	minWidthOfGap,          #@ 7 larger min gap is hard
	maxWidthOfGap,          #@ 8 larger max gap is hard
	previousGroundWidth,    # 9 documents width of ground
	lastHeightofPreviousChunk
	]

func GetDiff():
	Construct()
	var difficulty = 0
	for param in Paramaters:
		difficulty += float(GetWeight(float(param), float(len(Paramaters)))) * float(param)
	return difficulty

func GetWeight(param, size):
	if param == 0:
		return 0
	else:
		return float(1/(size * param))
