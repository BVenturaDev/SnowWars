extends KinematicBody

onready var mesh = $model_snowball

var character_loc: Vector3
var fall_loc: Vector3
var b_hittable = false
var timer_move: float = 0
var timer_follow: float = 0
var timer_fall: float = 0
var interp_rate_secs: float = 2.0
var interp_alpha: float
var stop_interp: bool
var reset_timer: bool

const follow_delay_secs: float = 0.3
const damage: float = 50.0

# Called when the node enters the scene tree for the first time.
func _ready():
	#mesh.visible = false
	if is_instance_valid(Globals.character) and Globals.character:
		character_loc = Globals.character.translation
		var start_loc = character_loc
		start_loc.x += 20.0
		translation = start_loc

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(Globals.character) and Globals.character:
		timer_move += delta
		character_loc = Vector3(Globals.character.translation.x, 0.4, Globals.character.translation.z)
		if timer_move <= 2:
			translation = translation.linear_interpolate(character_loc, interp_alpha)
			interp_alpha = clamp(interp_alpha + delta / interp_rate_secs, 0, 1)
		elif timer_move <= 4:
			timer_follow += delta
			fall_loc = Vector3(character_loc.x, 0.4, character_loc.z - 5)
			if timer_follow > follow_delay_secs:
				translation = translation.linear_interpolate(character_loc, interp_alpha)
				interp_alpha = clamp(interp_alpha + (delta / follow_delay_secs), 0, 1)
				if interp_alpha == 1:
					timer_follow = 0
		else:
			timer_fall += delta
			if translation != fall_loc:
				translation = translation.linear_interpolate(fall_loc, interp_alpha)
				interp_alpha = clamp(interp_alpha + delta, 0, 1)
			elif timer_fall > 1 and !stop_interp:
				mesh.translation = mesh.translation.linear_interpolate(Vector3(0, 0, 0), interp_alpha)
				interp_alpha = clamp(interp_alpha + delta * 2, 0, 1)
			elif mesh.translation == Vector3(0, 0, 0):
				stop_interp = true
				$snowbomb_col.disabled = false
			if timer_move > 6:
				queue_free()
		if interp_alpha == 1:
			interp_alpha = 0

func _physics_process(_delta):
	var hit = move_and_collide(Vector3(0, 0, 0))
	if hit:
		if hit.collider.get_class() == "KinematicBody":
			if hit.collider.b_hittable:
				hit.collider.take_damage(damage)
