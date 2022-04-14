extends Control

onready var quit_btn := $VBoxContainer/quit_btn

func _ready():
	if OS.get_name() == "HTML5":
		quit_btn.visible = false

func _on_resume_btn_pressed():
	get_tree().paused = false
	visible = false

func _on_options_btn_pressed():
	get_parent().get_node("options_menu").visible = true

func _on_quit_btn_pressed():
	get_tree().quit()

