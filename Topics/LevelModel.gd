extends Node
class_name LevelModel


#the amount of gaps that a level segment contains, the amount of platforms that a level segment contains,
#the width of these platforms, the amount of enemies a level segment contains and the kinds of enemies
#that are placed in the level segment.
#the maximum amount of gaps in the level segment, the maximum amount of enemies in the level segment
#and the maximum amount of coin blocks in the level segment. In case of the flow-driven level segment
#generator these input parameters are the chances to pick a part from a certain parts pool and their
#accompanying difficulty

var numberOfGaps = 0
var numberOfPlatforms = 0
var numberOfEnemies = 0
var maxNumberOfGapsAllowed = 3
var maxNumberOfEnemies = 0
var minChangeInHeight = 0
var minWidthOfGap = 1
var maxWidthOfGap = 0
var previousGapWidth = 0
var previousGroundWidth = 0
var maxGroundWidth = 0

func _init():
	pass

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
	#print("width: ", width)
	#print("Previous: ", previousGapWidth)
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
	print("min width of gap: ", minWidthOfGap)
	print("max width of gap: ", previousGapWidth)
	print("====================")
