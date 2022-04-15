extends Node

onready var track1 := $track1
onready var track2 := $track2
onready var theme := $theme

var cur_song

func _ready():
	_pick_song()

func _process(_delta):
	if not cur_song.playing:
		_pick_song()

func _pick_song():
	var song_num = Globals.rng.randi_range(1, 3)
	if song_num == 1:
		track1.play()
		cur_song = track1
	elif song_num == 2:
		track2.play()
		cur_song = track2
	else:
		theme.play()
		cur_song = theme
