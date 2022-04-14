extends Control

onready var lose_screen := $lose_screen
onready var score_label := $score_label
onready var lose_score_label := $lose_screen/lose_score_label
onready var pause_menu := $pause_menu

func _process(_delta):
	if lose_screen.visible:
		lose_score_label.text = "Score: " + str(Globals.total_score)
	else:
		score_label.text = "Score: " + str(Globals.total_score)


func _on_play_again_pressed():
	var _a = get_tree().reload_current_scene()
