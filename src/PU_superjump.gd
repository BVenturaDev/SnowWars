extends Spatial

var timer

func _process(delta):
	timer += delta
	if timer > 5.0:
		queue_free()

func _on_Area_body_entered(body):
	if body == Globals.character:
		Globals.character.velocity.y = 30.0
		
