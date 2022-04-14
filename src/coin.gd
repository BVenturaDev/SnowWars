extends Spatial

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):


func _on_Area_body_entered(body):
	if body == Globals.character:
		Globals.character.take_damage(-1)
		Globals.coin_score += 1
		queue_free()
