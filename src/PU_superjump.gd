extends Spatial

var b_pressed: bool
var pressed_y = -1.0

func _process(delta):
	if b_pressed:
		var alpha = 0
		var current_translation = translation
		var pressed_translation = Vector3(translation.x, translation.y + pressed_y, translation.z)
		if alpha < 1:
			translation = translation.linear_interpolate(pressed_translation, alpha)
			alpha = clamp(alpha + delta * 2, 0, 1)
		else:
			translation = current_translation.linear_interpolate(pressed_translation, alpha)
			alpha -= delta * 2
			if alpha <= 0:
				b_pressed = false
			

func _on_Area_body_entered(body):
	if body == Globals.character:
		$jump_sfx.play()
		Globals.coin_score += 10
		Globals.character.velocity.y = 13.0
		Globals.character.super_jump = true
		b_pressed = true
