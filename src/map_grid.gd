extends Spatial

var left_bank_grid_pos: Array = []
var left_bank_grid_objects: Array = []
var right_bank_grid_pos: Array = []
var right_bank_grid_objects: Array = []
var trench_grid_pos: Array = []
var trench_grid_objects: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	_generate_grid_arrays()

func _generate_grid_arrays():
	# Generate left_bank_grid
	for y in range(0, Globals.BANK_SIZE_Y):
		# Create sub arrays for each x in the y row
		var row_left: Array = []
		var row_right: Array = []
		var row_objects: Array = []
		for x in range(0, Globals.BANK_SIZE_X):
			# Get the local position
			var offset_x: float = -(float(Globals.BANK_SIZE_X) / 2.0 + float(Globals.TRENCH_SIZE_X) / 2.0)
			offset_x -= float(Globals.BANK_SIZE_X) / 2.0 - float(x) - 0.5
			var offset_y: float = float(Globals.BANK_SIZE_Y) / 2.0 - float(y) - 0.5
			# Y on grid = Z in game space
			var pos_left: Vector3 = Vector3(offset_x, Globals.HEIGHT, offset_y)
			var pos_right: Vector3 = Vector3(-offset_x, Globals.HEIGHT, offset_y)
			row_left.append(pos_left)
			row_right.append(pos_right)
			# Make an empty array for the objects
			row_objects.append(null)
			
		left_bank_grid_pos.append(row_left)
		right_bank_grid_pos.append(row_right)
		left_bank_grid_objects.append(row_objects)
		right_bank_grid_objects.append(row_objects)
	
	# Generate the trench grid
	for y in range(0, Globals.BANK_SIZE_Y):
		var row: Array = []
		var row_objects: Array = []
		for x in range(0, Globals.TRENCH_SIZE_X):
			var offset_x: float = -(float(Globals.TRENCH_SIZE_X) / 2.0) + float(x) + 0.5
			var offset_y: float = float(Globals.BANK_SIZE_Y) / 2.0 - float(y) - 0.5
			# Y on grid = Z in game space
			var pos: Vector3 = Vector3(offset_x, Globals.TRENCH_HEIGHT, offset_y)
			row.append(pos)
			# Make an empty array for the objects
			row_objects.append(null)
		trench_grid_pos.append(row)
		trench_grid_objects.append(row_objects)
		
func left_bank_add_object(new_object, x, y):
	left_bank_grid_objects[y][x] = new_object
	add_child(new_object)
	new_object.translation = get_pos_left_bank(x, y)
	
func right_bank_add_object(new_object, x, y):
	right_bank_grid_objects[y][x] = new_object
	add_child(new_object)
	new_object.translation = get_pos_right_bank(x, y)

func trench_add_object(new_object, x, y):
	trench_grid_objects[y][x] = new_object
	add_child(new_object)
	new_object.translation = get_pos_trench(x, y)

func add_tree(new_object, y):
	for x in range(0, Globals.TRENCH_SIZE_X):
		trench_grid_objects[y][x] = new_object
		if x == 0:
			add_child(new_object)
			new_object.translation = get_pos_trench(x, y)

func left_bank_remove(x, y):
	left_bank_grid_objects[y][x].queue_free()
	left_bank_grid_objects[y][x] = null
	
func right_bank_remove(x, y):
	right_bank_grid_objects[y][x].queue_free()
	right_bank_grid_objects[y][x] = null

func trench_remove(x, y):
	trench_grid_objects[y][x].queue_free()
	trench_grid_objects[y][x] = null

func get_pos_left_bank(x, y):
	return left_bank_grid_pos[y][x]

func get_pos_right_bank(x, y):
	return right_bank_grid_pos[y][x]

func get_pos_trench(x, y):
	return trench_grid_pos[y][x]
	
func find_empty_rows() -> Array:
	var empty_rows: Array = []
	for y in range(0, Globals.BANK_SIZE_Y):
		var b_is_empty: bool = false
		for x in range(0, Globals.BANK_SIZE_X):
			if left_bank_grid_objects[y][x]:
				b_is_empty = true
			if right_bank_grid_objects[y][x]:
				b_is_empty = true
		for tx in range(0, Globals.TRENCH_SIZE_X):
			if trench_grid_objects[y][tx]:
				b_is_empty = true
		if not b_is_empty:
			empty_rows.append(y)
	return empty_rows

# side = 'b' for bank 't' for trench
# The array is [0] = y [1] = x, null if no position
func find_empty_pos(side):
	var rand_pos: Array = []
	var empty_rows = find_empty_rows()
	var b_found_empty_y: bool = false
	while not b_found_empty_y:
		var rand_y = Globals.rng.randi_range(0, Globals.BANK_SIZE_Y - 1)
		for y in empty_rows:
			if rand_y == y:
				rand_pos.append(rand_y)
				b_found_empty_y = true
	if side == 'b':
		rand_pos.append(Globals.rng.randi_range(0, Globals.BANK_SIZE_X - 1))
	else:
		rand_pos.append(Globals.rng.randi_range(0, Globals.TRENCH_SIZE_X - 1))
	return rand_pos
	
func find_line(x, length):
	var positions: Array = []
	for y in range(0, length):
		if not trench_grid_objects[y][x]:
			positions.append(get_pos_trench(x, y))
		else:
			var pos = get_pos_trench(x, y)
			pos.y += 1.0
			if trench_grid_objects[y][x].is_in_group("trees"):
				if trench_grid_objects[y][x].is_blocked(x):
					return positions
				else:
					positions.append(pos)
			else:
				positions.append(pos)
	return positions
