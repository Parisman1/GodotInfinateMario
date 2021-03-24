extends Node2D

var X = 0 # used to know next region of chunck to be generated 
var borders = Rect2(X, -9, 57, 13) # border of each chunk w/ a x variable

onready var player = $Player
onready var tileMap = $TileMap
onready var last_block = $Area2D
onready var spawn = $Spawn
onready var model : Player_Model
onready var level_model : LevelModel
onready var generator : Generator
const Enemy = preload('res://Enemy/Enemy.tscn')
onready var score_label = player.get_node('HUD/Score')
onready var Max_label = player.get_node("HUD/MaxScore")
var best_score = 0

var distance = 0 # used to tell when the player has traveled enough distance
var paramaters = []
var player_paramaters = []
var persieved_difficulty = 0
var difficulty = 0

var avg_diff: float = 0.0
var avg_p_diff: float = 0.0
var NumChunks: float = 0.0
var total_chunks:int = 0

var CHUNK = []
var CHUNKS = []

#--name: _ready()
# paramaters: NA
# return: NA
# description: 
#	sets randomizer
#	sets borders
#	generates first chunk
func _ready():
	CHUNK.resize(5)
	get_tree().set_auto_accept_quit(false)
	randomize()
	borders = borders.abs()
	first_gen()
	pass

func first_gen():
	#print("===================== FIRST CHUNK =============================")
	generator = Generator.new(Vector2(X, 3), borders, last_block, spawn, [], tileMap)
	var map = generator.walk()
	level_model = generator.getModel()
	difficulty = level_model.GetDiff()
	#print('dif: ', difficulty)
	avg_diff += difficulty
	paramaters = level_model.GetParamaters()
	NumChunks += 1.0
	total_chunks += 1
	score_label.set_text('SCORE: ' + str(NumChunks))
	
	generator.queue_free()
	for index in range(map[0].size()):
		tileMap.set_cellv(map[0][index], map[1][index]) 
	tileMap.update_bitmask_region(borders.position, borders.end)
	
	if len(map[2]) != 0:
		Spawn_Enemy(map[2])
	
	CHUNK[0] = total_chunks
	CHUNK[1] = difficulty
	CHUNK[2] = len(map[2])
	CHUNK[3] = level_model.numberOfGaps
	
	distance += 57 * tileMap.cell_size.x
	X += 56
	borders = Rect2(X, -9, 57, 13)

#--name: _process()
# paramaters: delta
# return: NA
# description: 
#	calls check_generation each tick
# warning-ignore:unused_argument
func _physics_process(delta):
	check_generation()


#--name: generate()
# paramaters: NA
# return: NA
# description: 
#	makes an instance of the generator class and generates a chunk
#	gives the generated blocks to the tilemap and updates auto tiler
func generate():
	#print("===================== NEW CHUNK =============================")
	borders = Rect2(X, -9, 57, 13)
	generator = Generator.new(Vector2(X, 3), borders, last_block, spawn, level_model.GetParamaters(), tileMap)
	var map = generator.walk()
	level_model.queue_free()
	level_model = generator.getModel()
	difficulty = level_model.GetDiff()
	paramaters = level_model.GetParamaters()

	avg_diff += difficulty
	
	NumChunks += 1.0
	total_chunks += 1
	score_label.set_text('SCORE: ' + str(NumChunks))
	
	generator.queue_free()
	for index in range(map[0].size()):
		tileMap.set_cellv(map[0][index], map[1][index]) 
	tileMap.update_bitmask_region(borders.position, borders.end)
	
	if len(map[2]) != 0:
		Spawn_Enemy(map[2])
	
	CHUNK[0] = total_chunks
	CHUNK[1] = difficulty
	CHUNK[2] = len(map[2])
	CHUNK[3] = level_model.numberOfGaps
	
	distance += 57 * tileMap.cell_size.x
	X += 56
	


#--name: check_generation()
# paramaters: NA
# return: NA
# description: 
#	checks to see if the player has made enough progress to generate next chunk
#	if true calls generate() and updates border to be used by next chunk
func check_generation():
	if player.die == true:
		player.die = false

		avg_diff /= NumChunks
		avg_p_diff /= NumChunks
		
		if NumChunks > best_score:
			best_score = NumChunks
		Max_label.set_text('BEST: ' + str(best_score))
		NumChunks = 0
		
		CHUNK[4] = 1
		CHUNKS.append([] + CHUNK)

		for tile in tileMap.get_used_cells():
			tileMap.set_cellv(Vector2(tile.x, tile.y), -1)
		borders = Rect2(X, -9, 57, 13) # border of each chunk w/ a x variable
		X = 0
		
		var group = get_tree().get_nodes_in_group('Enemies')
		for _i in group:
			if 'E' in _i.get_name():
				_i.queue_free()

		level_model.DecreaseDiff()
		
		spawn.reset_once()
		generate()
		player.set_spawn(spawn)

	if last_block.generate:
		last_block.generate = false
		model = player.GetModel()
		model.calculateAvg()
		persieved_difficulty = model.Getpersieved_difficulty()
		avg_p_diff += persieved_difficulty
		player_paramaters = model.GetParams()
		
		CHUNK[4] = persieved_difficulty
		CHUNKS.append([] + CHUNK)

		
		if float(abs(float(persieved_difficulty) - float(difficulty))) >= .1: # if the difficulty and p_difficulty are not close enough
			if persieved_difficulty < difficulty: # chunk was too easy
				level_model.IncreaseDiff()
			else: # chunk was too hard
				level_model.DecreaseDiff()
		
		generate()
		model.queue_free()

func Spawn_Enemy(SPawn):
	for pos in SPawn:
		var enemy = Enemy.instance().init() # make sure init returns self
		add_child(enemy)
		enemy.add_to_group('Enemies')
		enemy.set_pos((pos + Vector2.UP) * tileMap.cell_size.x)

func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		save_game()
		get_tree().quit()


func save_game():
	var num = 0
	var save_game = File.new()
	var cwd = OS.get_executable_path()
	while save_game.file_exists(str(cwd) + str(num) + "_Stats.txt"):
		num += 1
	save_game.open(str(cwd) + str(num) + "_Stats.txt", File.WRITE)
	
	save_game.store_line("numChunks: " +  str(total_chunks))
	
	for i in CHUNKS:
		save_game.store_line(str(i))

	save_game.close()
