extends Spatial

const map_grid := preload("res://scenes/map_grid.tscn")
const snowman_shooter := preload("res://scenes/snowman_shooter.tscn")
const stump := preload("res://scenes/stump.tscn")
const tree := preload("res://scenes/tree.tscn")
const coin := preload("res://scenes/coin.tscn")
const snowbomb := preload("res://scenes/snowbomb.tscn")

onready var light := $DirectionalLight

var grids: Array = []
var timer: float = 0
var last_bomb

# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.get_name() == "HTML5":
		light.light_energy = 1.0
	else:
		light.light_energy = 0.5

	Globals.get_values()
	_generate_grids()
	
func add_grid(last_grid_pos):
	var new_grid := map_grid.instance()
	add_child(new_grid)
	grids.append(new_grid)
	new_grid.translation = last_grid_pos
	new_grid.translation.z -= float(Globals.BANK_SIZE_Y)
	
	# Generate stumps
	var max_objects = 1.0 + Globals.score_multiplier
	max_objects = clamp(max_objects, 1.0, 2.0)
	var amount = Globals.rng.randi_range(0, float(max_objects))
	for i in range(0, amount):
		var tpos = new_grid.find_empty_pos('t')
		if tpos:
			var new_stump = stump.instance()
			new_grid.trench_add_object(new_stump, tpos[1], tpos[0])
	
	# Generate logs
	amount = Globals.rng.randi_range(0, float(max_objects))
	for i in range(0, int(amount)):
		var tree_pos = new_grid.find_empty_pos('t')
		if tree_pos:
			var new_tree = tree.instance()
			new_grid.add_tree(new_tree, tree_pos[0])
	
	_generate_coins(new_grid)
	
	# Generate snowmen on right and left
	max_objects = 1.0 + Globals.score_multiplier
	max_objects = clamp(max_objects, 1.0, 3.0)
	amount = Globals.rng.randi_range(0, float(max_objects))
	for i in range(0, amount):
		var lpos = new_grid.find_empty_pos('b')
		if lpos:
			var snowman := snowman_shooter.instance()
			snowman.b_red_team = true
			new_grid.left_bank_add_object(snowman, lpos[1], lpos[0])
	
	amount = Globals.rng.randi_range(0, float(max_objects))
	for i in range(0, amount):	
		var rpos = new_grid.find_empty_pos('b')
		if rpos:
			var snowman := snowman_shooter.instance()
			snowman.b_red_team = false
			new_grid.right_bank_add_object(snowman, rpos[1], rpos[0])
	return new_grid.translation
			
func _generate_grids():
	var new_grid := map_grid.instance()
	add_child(new_grid)
	grids.append(new_grid)
	for i in range(1, 18):
		add_grid(grids[i - 1].translation)
		
func _generate_coins(map_grid):
	var min_length = 2.0 - Globals.score_multiplier
	min_length = clamp(min_length, 0.0, 2.0)
	var max_length = 9.0 - Globals.score_multiplier
	max_length = clamp(max_length, 6.0, 9.0)
	var length = int(Globals.rng.randf_range(min_length, max_length))
	var x = Globals.rng.randi_range(0, Globals.TRENCH_SIZE_X - 1)
	var positions = map_grid.find_line(x, length)
	if not positions.size() == 0:
		for pos in positions:
			var new_coin = coin.instance()
			map_grid.add_child(new_coin)
			new_coin.translation = pos

func _check_grids():
	if -(Globals.character.translation. z - grids.front().translation.z) > Globals.MAX_DISTANCE:
		grids[0].queue_free()
		grids.remove(0)
	if -(grids.back().translation.z - Globals.character.translation.z) < Globals.MAX_DISTANCE:
		add_grid(grids[grids.size() - 1].translation)

func _process(delta):
	if not is_instance_valid(last_bomb):
		last_bomb = null
		
	if is_instance_valid(Globals.character):
		_check_grids()
		timer += delta
		if timer > Globals.SNOWBOMB_RATE - Globals.score_multiplier and not last_bomb:
			var new_snowbomb = snowbomb.instance()
			add_child(new_snowbomb)
			last_bomb = new_snowbomb
			timer = 0
