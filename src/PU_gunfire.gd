extends Spatial

var start_timer: bool
var timer: float
var snowmen
var targets: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if start_timer:
		timer += delta
	if timer > 5.0:
			queue_free()


func _on_Area_body_entered(body):
	if body == Globals.character:
		# get all snowmen shooter within a forward raneg of 10
		snowmen = get_tree().get_nodes_in_group("snowman_shooter")
		for a in snowmen:
			if a.translation.z > Globals.character.translation.z:
				if Globals.character.translation.distance_to(a.translation) < 10.0:
					targets.append(a)
		# fire character function
		Globals.character.gunfire_PU(targets)
		start_timer = true
		
