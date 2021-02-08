extends Node2D

var borders = Rect2(0, 0, 32, 32)


onready var tileMap = $TileMap

func _ready():
	randomize()
	#borders = borders.abs()
	print("end: ", borders.get_area())
	#print("position: ", borders.position())
	generate()
	
func generate():
	var generator = Generator.new(Vector2(5, 5), borders)
	var map = generator.walk(500)
	generator.queue_free()
	for location in map:
		tileMap.set_cellv(location, 0)
	tileMap.update_bitmask_region(borders.position, borders.end)
