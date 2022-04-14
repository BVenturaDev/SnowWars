extends Control

onready var close_btn := $close

func _on_shadows_checkbox_toggled(button_pressed):
	if Globals.light:
		Globals.light.shadow_enabled = button_pressed

func _on_close_pressed():
	visible = false
	get_parent().pause_menu.resume_btn.grab_focus()
