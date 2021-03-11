extends Node
class_name Player_Model

#list of paramaters
var timeStandingStill = 0
var timeMovingLeft = 0
var timeMovingRight = 0
var timeJumping = 0
var timeInAir = 0
var numberOfJumps = 0
var timeSpent = 0
var averageSpeed = 0
var totalVerticalMovement = 0
var timeRunning = 0

var timeStart = 0
var timeEnd = 0

var Paramaters = []

func _init():
	TimeStart()

func Still(amount):
	timeStandingStill += amount

func MovingLeft(amount):
	timeMovingLeft += amount

func MovingRight(amount):
	timeMovingRight += amount

func Jumping(amount):
	timeJumping += amount

func inAir(amount):
	timeInAir += amount

func JumpCounter(amount):
	numberOfJumps += amount

func TimeStart():
	timeStart = OS.get_unix_time()

func TimeEnd():
	timeEnd = OS.get_unix_time()
	timeSpent = timeEnd - timeStart
	if timeSpent == 0:
		timeSpent = 0.01

func Speed(amount):
	averageSpeed += amount

func VerticalHeight(amount):
	totalVerticalMovement += amount

func Running(amount):
	timeRunning += amount

func calculateAvg():
	averageSpeed /= timeSpent

func Print():
	print("--------------------")
	print("StandingStill: ", timeStandingStill)
	print("MovingLeft: ", timeMovingLeft)
	print("MovingRight: ", timeMovingRight)
	print("TimeJumping: ", timeJumping)
	print("TimeInAir: ", timeInAir)
	print("NumberOfJumps: ", numberOfJumps)
	print("TimeStart and End: ", timeStart, ", ", timeEnd)
	print("TimeSpent: ", timeSpent)
	print("AverageSpeed: ", averageSpeed)
	print("TimeRunning: ", timeRunning)
	print("--------------------")

func Construct():
	Paramaters = [timeStandingStill, #0 means lower persieved_difficulty
				  timeMovingLeft,    #1 means lower persieved_difficulty
				  timeMovingRight,   #2 higher persieved_difficulty
				  timeJumping,       #3 neutral
				  timeInAir,         #4 neutral
				  numberOfJumps,     #5 high jumps means .... low persieved_difficulty?
				  timeSpent,         #6 high time spent means low persieved_difficulty
				  averageSpeed,      #7 high avg speed == hi persieved_difficulty
				  timeRunning]       #8 running a lot means hi persieved_difficulty

func Getpersieved_difficulty():
	Construct()
	var persieved_difficulty = 0
	persieved_difficulty += float(GetWeight(float(Paramaters[0]), float(len(Paramaters)))) * float(Paramaters[0])
	persieved_difficulty += float(GetWeight(float(Paramaters[1]), float(len(Paramaters)))) * float(Paramaters[1])
	persieved_difficulty -= float(GetWeight(float(Paramaters[2]), float(len(Paramaters)))) * float(Paramaters[2]) * 0.2
	persieved_difficulty += float(GetWeight(float(Paramaters[3]), float(len(Paramaters)))) * float(Paramaters[3])
	persieved_difficulty += float(GetWeight(float(Paramaters[4]), float(len(Paramaters)))) * float(Paramaters[4])
	persieved_difficulty += float(GetWeight(float(Paramaters[5]), float(len(Paramaters)))) * float(Paramaters[5])
	persieved_difficulty += float(GetWeight(float(Paramaters[6]), float(len(Paramaters)))) * float(Paramaters[6])
	persieved_difficulty -= float(GetWeight(float(Paramaters[7]), float(len(Paramaters)))) * float(Paramaters[7])
	persieved_difficulty -= float(GetWeight(float(Paramaters[8]), float(len(Paramaters)))) * float(Paramaters[8])
#	for param in Paramaters:
#		persieved_difficulty += float(GetWeight(float(param), float(len(Paramaters)))) * float(param)
	if persieved_difficulty < 0:
		persieved_difficulty = 0
	return persieved_difficulty

func GetParams():
	return Paramaters

func GetWeight(param, size):
	if param == 0:
		return 0
	else:
		return float(1/(size * param))
