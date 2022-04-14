extends Control

func _on_shadows_checkbox_toggled(button_pressed):
	if Globals.light:
		Globals.light.shadow_enabled = button_pressed

func _on_close_pressed():
	visible = false
