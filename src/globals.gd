extends Node

const BANK_SIZE_X: int = 8
const BANK_SIZE_Y: int = 10
const TRENCH_SIZE_X: int = 6
const HEIGHT: float = 0.5
const TRENCH_HEIGHT: float = 0.25
const SNOWBOMB_RATE: float = 15.0
const MAX_DISTANCE: float = 100.0

var character
var gui
var light

var rng = RandomNumberGenerator.new()

var counter: int

var coin_score: int = 0
var total_score: int = 0
var score_multiplier: float = 0

var high_scores: Array = []

func _process(_delta):
	if is_instance_valid(character):
		total_score = -int(character.translation.z / 10.0) + coin_score
		score_multiplier = float(total_score) / 100.0

func get_values():
	coin_score = 0
	total_score = 0
	character = get_node("/root/main/player_character")
	gui = get_node("/root/main/CanvasLayer/GUI")
	light = get_node("/root/main/DirectionalLight")
	rng.randomize()

func _ready():
	get_values()
	for _i in range(0, 5):
		high_scores.append(0)
	if not OS.get_name() == "HTML5":
		load_scores()

func check_high_scores():
	for i in range(high_scores.size() - 1, 0, -1):
		if total_score > high_scores[i]:
			high_scores.append(total_score)
			break
	high_scores.sort()
	if high_scores.size() > 5:
		high_scores.remove(0)
	if not OS.get_name() == "HTML5":
		save_scores()

func load_scores():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return false
	var load_scores: Array = []
	save_game.open("user://savegame.save", File.READ)
	while not save_game.eof_reached():
		load_scores.append(int(save_game.get_line()))
	save_game.close()
	for i in range(0, load_scores.size() - 1):
		high_scores[i] = load_scores[i]
	return true

func save_scores():
	var save_game = File.new()
	if save_game.file_exists("user://savegame.save"):
		var dir = Directory.new()
		dir.remove("user://savegame.save")
	save_game.open("user://savegame.save", File.WRITE)
	for i in range(0, high_scores.size()):
		save_game.store_line(str(high_scores[i]))
	save_game.close()
