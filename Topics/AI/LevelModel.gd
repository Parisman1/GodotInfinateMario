extends Node
class_name LevelModel

var numberOfGaps = 0
var numberOfPlatforms = 0
var numberOfEnemies = 0
var maxNumberOfGapsAllowed = 3
var maxNumberOfEnemies = 0
var minChangeInHeight = 0
var maxHeight = 4
var minWidthOfGap = 1
var maxWidthOfGap = 0
var previousGapWidth = 0
var previousGroundWidth = 0

var Paramaters = []

func _init(paramaters):
	if len(paramaters) == 0:
		numberOfGaps = 0
		numberOfPlatforms = 0
		numberOfEnemies = 0
		maxNumberOfGapsAllowed = 3
		maxNumberOfEnemies = 0
		minChangeInHeight = 0
		maxHeight = 4
		minWidthOfGap = 1
		maxWidthOfGap = 0
		previousGapWidth = 0
		previousGroundWidth = 0
	else:
		numberOfGaps = 0
		numberOfPlatforms = paramaters[1]
		numberOfEnemies = paramaters[2]
		maxNumberOfGapsAllowed = paramaters[3]
		maxNumberOfEnemies = paramaters[4]
		minChangeInHeight = paramaters[5]
		maxHeight = paramaters[6]
		minWidthOfGap = paramaters[7]
		previousGapWidth = paramaters[8]
		previousGroundWidth = paramaters[9 ]

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
	if width > previousGapWidth:
		previousGapWidth = width

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
	print("max width of gap: ", previousGapWidth)
	print("max ground width ", previousGroundWidth)
	print("====================")
	
func Construct():
	Paramaters = [numberOfGaps, numberOfPlatforms, numberOfEnemies, maxNumberOfGapsAllowed,
	 maxNumberOfEnemies, minChangeInHeight, maxHeight, minWidthOfGap, previousGapWidth, previousGroundWidth]


#TO DO GENETIC FUCKING SHIT, TAKE THE PARAMATER LIST, GENERATE A BLOCK, CHECK THE DIFF, IF DIFF NOT HIGHER OR LOWER BASED
#ON SKILL OF PLAYER, DO IT AGAIN, UP TO 3 TIMES AND TAKE THE BEST ONE I SUPPOSE, SHIT WILL TAKE YEARS SO WILL HAVE
#TO TWEAK FINALLY FITNESS FUNCTION WILL MAYBE BE USED


func GetParamaters():
	return Paramaters

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
