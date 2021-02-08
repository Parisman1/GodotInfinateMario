extends KinematicBody2D
#extends Node2D

signal player

export var fallMultiplier = 2 
export var lowJumpMultiplier = 10 
export var jumpVelocity = 250 #Jump height
export var backSpeedMultiplier = 0.2

export var SPEED = 200
export var GRAVITY = 10
const FLOOR = Vector2(0, -1)
var die = false

var Velocity = Vector2()

var on_ground = false
var facingR = true
var anim = ""
var speedBeforeJump = 0
var oldSpeed = 200
var newSpeed = 275
var once = true

export var Lives = 3

func _ready():
	pass # Replace with function body.

func GetPos():
	return global_position


func _process(_delta):
	Velocity.y += GRAVITY

	if Input.is_action_pressed("Run"):
		if $AnimatedSprite.speed_scale == 1:
			$AnimatedSprite.speed_scale = $AnimatedSprite.speed_scale * 2
		SPEED = newSpeed
	else:
		$AnimatedSprite.speed_scale = 1
		SPEED = oldSpeed
	
	if on_ground: # if on the ground do normal animations and speed calculations
		if Input.is_action_pressed("ui_right"):
			facingR = true
			#Velocity.x = SPEED
			Velocity.x = lerp(Velocity.x, SPEED, 0.05)
			$AnimatedSprite.play("WalkR")
		elif Input.is_action_pressed("ui_left"):
			facingR = false
			Velocity.x = lerp(Velocity.x, -SPEED, 0.05)
			$AnimatedSprite.play("WalkL")
		else:
			Velocity.x = lerp(Velocity.x, 0, 0.1)
			if on_ground:
				if facingR:
					$AnimatedSprite.play("IdleR")
				else:
					$AnimatedSprite.play("IdleL")
	else: # else if they are in the air change how speed and animations are handled
		if Input.is_action_pressed("ui_right"):
			if facingR:
				if Velocity.x == 0: # standing still
					Velocity.x = lerp(Velocity.x, SPEED, 0.1)
				else: # when already moving
					Velocity.x = lerp(Velocity.x, SPEED, 0.05)
			else: # facing opposite direction
				Velocity.x = lerp(Velocity.x, SPEED, 0.05)
		elif Input.is_action_pressed("ui_left"):
			if !facingR:
				if Velocity.x == 0: # standing still
					Velocity.x = lerp(Velocity.x, -SPEED, 0.1)
				else: # when already moving
					Velocity.x = lerp(Velocity.x, -SPEED, 0.05)
			else: # facing opposite direction
				Velocity.x = lerp(Velocity.x, -SPEED, 0.05)
		
		if facingR:
			$AnimatedSprite.play("JumpR")
		else:
			$AnimatedSprite.play("JumpL")

	#mario physc
	if Velocity.y > 0:
		Velocity += Vector2.UP * (-9.81) * fallMultiplier
	elif Velocity.y < 0 && Input.is_action_just_released("ui_up"):
		Velocity += Vector2.UP * (-9.81) * lowJumpMultiplier	
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			speedBeforeJump = Velocity.x
			Velocity = Vector2.UP * jumpVelocity
			Velocity.x = speedBeforeJump
	
	if is_on_floor():
		on_ground = true
	else:
		on_ground = false
			
	if global_position.y >= 40:
		die = true
		
	if die:
		Die()
	
	Velocity = move_and_slide(Velocity, FLOOR)
	
func Die():
	self.global_position = Vector2(12, -8)
	die = false
	#Lives -= 1
	#if Lives <= 0:
		
