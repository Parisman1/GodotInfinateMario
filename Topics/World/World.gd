extends Node2D

var X = 0 # used to know next region of chunck to be generated 
var borders = Rect2(X, -9, 57, 13) # border of each chunk w/ a x variable


onready var player = $Player
onready var tileMap = $TileMap
onready var generator = Generator.new(Vector2(X, 3), borders, player, [])

var distance = 0 # used to tell when the player has traveled enough distance
var model = Player_Model.new()
var level_model = LevelModel.new([])
var paramaters = []
var player_paramaters = []
var persieved_difficulty = 0
var difficulty = 0

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
	generator = Generator.new(Vector2(X, 3), borders, player, level_model.GetParamaters())
	var map = generator.walk(1000)
	level_model.queue_free()
	
	level_model = generator.getModel()
	difficulty = level_model.GetDiff()
	paramaters = level_model.GetParamaters()
	print("difficulty: ", difficulty)
	print(" ")
	
	generator.queue_free()
	
	for index in range(map[0].size()):
		tileMap.set_cellv(map[0][index], map[1][index]) #  
	tileMap.update_bitmask_region(borders.position, borders.end)
	
	distance += 57 * tileMap.cell_size.x
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

	if player.GetPos().x > (distance - (15 * tileMap.cell_size.x)):
		model = player.GetModel()
		model.calculateAvg()
		persieved_difficulty = model.Getpersieved_difficulty()
		player_paramaters = model.GetParams()
		print("persieved_difficulty: ", persieved_difficulty)
		
		if float(abs(float(persieved_difficulty) - float(difficulty))) >= .1: # if the difficulty and p_difficulty are not close enough
			print("difference: ", float(abs(float(persieved_difficulty) - float(difficulty))))
			if persieved_difficulty < difficulty: # chunk was too easy
				level_model.IncreaseDiff()
			else: # chunk was too hard
				level_model.DecreaseDiff()
			#print(paramaters)
		
		
		generate()
		model.queue_free()
		#level_model.queue_free()

	#var viewport_rect: Rect2 = tileMap.get_viewport_rect()
	#var viewport_transform: Transform2D = tileMap.get_viewport_transform()
	#var global_visible_rect: Rect2 = viewport_transform.affine_inverse().xform(viewport_rect)

