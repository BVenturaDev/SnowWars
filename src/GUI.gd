extends Control

onready var lose_screen := $lose_screen
onready var play_again_btn := $lose_screen/play_again
onready var score_label := $score_label
onready var lose_score_label := $lose_screen/lose_score_label
onready var pause_menu := $pause_menu
onready var credits_screen := $credits_screen
onready var credits_close := $credits_screen/close

onready var score1 := $lose_screen/VBoxContainer/high_score1
onready var score2 := $lose_screen/VBoxContainer/high_score2
onready var score3 := $lose_screen/VBoxContainer/high_score3
onready var score4 := $lose_screen/VBoxContainer/high_score4
onready var score5 := $lose_screen/VBoxContainer/high_score5

func _process(_delta):
	if lose_screen.visible:
		lose_score_label.text = "Score: " + str(Globals.total_score)
		if Globals.high_scores.size() == 5:
			score1.text = str(Globals.high_scores[4])
			score2.text = str(Globals.high_scores[3])
			score3.text = str(Globals.high_scores[2])
			score4.text = str(Globals.high_scores[1])
			score5.text = str(Globals.high_scores[0])
		else:
			print(Globals.high_scores)
	else:
		score_label.text = "Score: " + str(Globals.total_score)


func _on_play_again_pressed():
	var _a = get_tree().reload_current_scene()

func _on_close_pressed():
	credits_screen.visible = false
	pause_menu.visible = true
	pause_menu.resume_btn.grab_focus()
