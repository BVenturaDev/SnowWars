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

var rng = RandomNumberGenerator.new()

var counter: int

var coin_score: int = 0
var total_score: int = 0
var score_multiplier: float = 0

func _process(_delta):
	if is_instance_valid(character):
		total_score = -int(character.translation.z / 10.0) + coin_score
		score_multiplier = float(total_score) / 100.0

func get_values():
	coin_score = 0
	total_score = 0
	character = get_node("/root/main/player_character")
	gui = get_node("/root/main/CanvasLayer/GUI")
	rng.randomize()

func _ready():
	get_values()
