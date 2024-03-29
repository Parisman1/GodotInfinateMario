extends KinematicBody2D

# variables for mario like physics
export var fallMultiplier = 2 
export var lowJumpMultiplier = 10 
export var jumpVelocity = 250 #Jump height
export var backSpeedMultiplier = 0.2

# variables for 2d platform physics
export var SPEED = 200
export var GRAVITY = 10
export var Lives = 3

# CONSTS
const FLOOR = Vector2(0, -1)

# onready variables
onready var MySprite = $AnimatedSprite
onready var model = Player_Model.new()
onready var Camera = $Camera2D

var Velocity = Vector2()
var on_ground = false
var facingR = true # "Facing Right"
var speedBeforeJump = 0
var oldSpeed = 200
var newSpeed = 275
var die = false
var timeVariable = 1

func _ready():
	Camera.set_process_mode(0)
	GetModel()

#--name: _process()
# paramaters: _delta
# return: NA
# description: 
#	handles state of mario every tick
func _physics_process(_delta):
	Velocity.y += GRAVITY

	if Input.is_action_pressed("Run"):
		model.Running(timeVariable)
		if MySprite.speed_scale == 1:
			MySprite.speed_scale = MySprite.speed_scale * 2
			SPEED = newSpeed
	else:
		MySprite.speed_scale = 1
		SPEED = oldSpeed
	
	if on_ground: # if on the ground do normal animations and speed calculations
		if Input.is_action_pressed("ui_right"):
			model.MovingRight(timeVariable)
			facingR = true
			Velocity.x = lerp(Velocity.x, SPEED, 0.05)
			MySprite.play("WalkR")
		elif Input.is_action_pressed("ui_left"):
			model.MovingLeft(timeVariable)
			facingR = false
			Velocity.x = lerp(Velocity.x, -SPEED, 0.05)
			MySprite.play("WalkL")
		else:
			Velocity.x = lerp(Velocity.x, 0, 0.1)
			model.Still(timeVariable)
			if on_ground:
				if facingR:
					MySprite.play("IdleR")
				else:
					MySprite.play("IdleL")
					
	else: # else if they are in the air change how speed and animations are handled
		model.inAir(timeVariable)
		if Input.is_action_pressed("ui_right"):
			model.MovingRight(timeVariable)
			if facingR:
				if Velocity.x == 0: # standing still
					Velocity.x = lerp(Velocity.x, SPEED, 0.1)
				else: # when already moving
					Velocity.x = lerp(Velocity.x, SPEED, 0.05)
			else: # facing opposite direction
				Velocity.x = lerp(Velocity.x, SPEED, 0.05)
		elif Input.is_action_pressed("ui_left"):
			model.MovingLeft(timeVariable)
			if !facingR:
				if Velocity.x == 0: # standing still
					Velocity.x = lerp(Velocity.x, -SPEED, 0.1)
				else: # when already moving
					Velocity.x = lerp(Velocity.x, -SPEED, 0.05)
			else: # facing opposite direction
				Velocity.x = lerp(Velocity.x, -SPEED, 0.05)
		
		if facingR:
			MySprite.play("JumpR")
		else:
			MySprite.play("JumpL")

	Mario_Physics() # fixes physics calculations for mario feel
	Floor() # sets on_ground variable
	check_death() # checks state of player
	model.Speed(SPEED)
	
	Velocity = move_and_slide(Velocity, FLOOR) # calls physics engine 
# ---------- END OF _process ---------- # 

#--name: Mario_Physics()
# paramaters: NA
# return: NA
# description: 
#	does special in air calculations to make mario feel like Mario
func Mario_Physics():
	if Velocity.y > 0:
		Velocity += Vector2.UP * (-9.81) * fallMultiplier
	elif Velocity.y < 0 && Input.is_action_just_released("ui_up"):
		Velocity += Vector2.UP * (-9.81) * lowJumpMultiplier	
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			model.Jumping(timeVariable)
			model.JumpCounter(timeVariable)
			speedBeforeJump = Velocity.x
			Velocity = Vector2.UP * jumpVelocity
			Velocity.x = speedBeforeJump
	
#--name: check_death()
# paramaters: NA
# return: NA
# description: 
#	checks y position to decide if the layer should respawn
func check_death():
	if global_position.y >= 50:
		Die()
	
#--name: Die()
# paramaters: NA
# return: NA
# description: 
#	resets players position
#	TODO: set up new world w/ new generation
func Die():
	Velocity = Vector2(0,0)
	die = true

#--name: Floor()
# paramaters: NA
# return: NA
# description:
#	checks if player is on floor 
func Floor():
	if is_on_floor():
		on_ground = true
	else:
		on_ground = false

#--name: GetPos()
# paramaters: NA
# return: NA
# description: 
#	Gets the position of the player, used in World.gd
func GetPos():
	return global_position

func set_spawn(spawn):
	self.global_position = Vector2(spawn.global_position.x, spawn.global_position.y)

func GetModel():
	model.TimeEnd()
	var old_model = model
	model = Player_Model.new()
	return old_model
