extends KinematicBody2D

export var GRAVITY = 10
const FLOOR = Vector2(0, -1)
export var SPEED = 300

var Velocity:Vector2

func init():
	return self

func set_pos(spawn):
	for i in get_children():
		i.global_position = Vector2(spawn.x, spawn.y)

func _ready():
	pass


func _physics_process(_delta):
	if !is_on_floor():
		Velocity.y += GRAVITY
	else:
		Velocity.x -= lerp(Velocity.x, SPEED, 0.1)
		Velocity.y += lerp(Velocity.y, 0, 0.5)
		
	Check_Dead()
		
	Velocity = move_and_slide(Velocity, FLOOR)

func Check_Dead():
	if global_position.y >= 90:
		Die()


func Die():
	self.queue_free()



