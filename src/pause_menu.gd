extends Control

onready var resume_btn := $VBoxContainer/resume_btn
onready var quit_btn := $VBoxContainer/quit_btn

func _ready():
	if OS.get_name() == "HTML5":
		quit_btn.visible = false

func _on_resume_btn_pressed():
	get_tree().paused = false
	visible = false

func _on_options_btn_pressed():
	get_parent().get_node("options_menu").visible = true
	get_parent().get_node("options_menu").close_btn.grab_focus()

func _on_quit_btn_pressed():
	get_tree().quit()

func _on_credits_pressed():
	visible = false
	get_parent().credits_screen.visible = true
	get_parent().credits_close.grab_focus()
