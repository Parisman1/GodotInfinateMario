extends Node2D

var X = 0 # used to know next region of chunck to be generated 
var borders = Rect2(X, -9, 57, 13) # border of each chunk w/ a x variable


onready var player = $Player
onready var tileMap = $TileMap

var distance = 456 # used to tell when the player has traveled enough distance
var model

#--name: _ready()
# paramaters: NA
# return: NA
# description: 
#	sets randomizer
#	sets borders
#	generates first chunk
func _ready():
	randomize()
	borders = borders.abs()
	generate()
	player.GetModel()
	#generate()

#--name: _process()
# paramaters: delta
# return: NA
# description: 
#	calls check_generation each tick
# warning-ignore:unused_argument
func _process(delta):
	check_generation()
		

#--name: generate()
# paramaters: NA
# return: NA
# description: 
#	makes an instance of the generator class and generates a chunk
#	gives the generated blocks to the tilemap and updates auto tiler
func generate():
	var generator = Generator.new(Vector2(X, 3), borders, player)
	var map = generator.walk(1000)
	generator.queue_free()
	for index in range(map[0].size()):
		tileMap.set_cellv(map[0][index], map[1][index]) #  
	tileMap.update_bitmask_region(borders.position, borders.end)
	distance += 500
	X += 56
	borders = Rect2(X, -9, 57, 13)


#--name: check_generation()
# paramaters: NA
# return: NA
# description: 
#	checks to see if the player has made enough progress to generate next chunk
#	if true calls generate() and updates border to be used by next chunk
func check_generation():
	if player.die == true:
		player.die = false
		get_tree().reload_current_scene()
		
	if player.GetPos().x > distance/2:
		model = player.GetModel()
		model.calculateAvg()
		model.Print()
		generate()
		#start new player model
