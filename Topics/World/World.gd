extends Node2D

var X = 0
var borders = Rect2(X, -9, 57, 13)

onready var player = $Player
onready var tileMap = $TileMap
var once = false
#456
#39 blocks infrom of player
var distance = 456
func _ready():
	randomize()
	borders = borders.abs()
	print("end: ", borders.get_area())
	print("test: ", borders.end)
	print("player ", player.GetPos())
	generate()
	#print("position: ", borders.position())
	#generate()
	
	
# warning-ignore:unused_argument
func _process(delta):
	check_generation()
		
	
func generate():
	var generator = Generator.new(Vector2(X, 0), borders, player)
	var map = generator.walk(1000)
	generator.queue_free()
	for location in map:
		tileMap.set_cellv(location, 0)
	tileMap.update_bitmask_region(borders.position, borders.end)

func check_generation():
	if player.GetPos().x > distance/2:
		generate()
		#print("accept")
		distance += 456
		X += 56
		borders = Rect2(X, -9, 57, 13)
		#print("distance", distance)
