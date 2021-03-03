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





