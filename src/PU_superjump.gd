extends Spatial

var timer: float
var b_pressed: bool
var pressed_y = -1.0

func _process(delta):
	timer += delta
	if timer > 5.0:
		queue_free()
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
		Globals.character.velocity.y = 30.0
		b_pressed = true
