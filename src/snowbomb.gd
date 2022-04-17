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
var collision_on: bool
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
		if timer_move <= 1:
			translation = translation.linear_interpolate(character_loc, interp_alpha)
			interp_alpha = clamp(interp_alpha + delta / interp_rate_secs, 0, 1)
		elif timer_move <= 2:
			timer_follow += delta
			if timer_follow > follow_delay_secs:
				translation = translation.linear_interpolate(character_loc, interp_alpha)
				interp_alpha = clamp(interp_alpha + (delta / follow_delay_secs), 0, 1)
		elif timer_move <= 4:
			translation = translation.linear_interpolate(character_loc, interp_alpha / 2.0)
			interp_alpha = clamp(interp_alpha + delta / follow_delay_secs, 0, 1)
		elif mesh.translation != Vector3(0, 0, 0):
			if mesh.translation.x < 0.1:
				mesh.translation.x = 0
			if mesh.translation.y < 0.1:
				mesh.translation.y = 0
			if mesh.translation.z < 0.1:
				mesh.translation.z = 0
			# this is running for another 20-30 frames even when mesh.translation == Vector3(0, 0, 0)
			#print(mesh.translation)
			mesh.translation = mesh.translation.linear_interpolate(Vector3(0, 0, 0), interp_alpha / 1.5)
			interp_alpha = clamp(interp_alpha + delta, 0, 1)
		elif !collision_on:
			$snowbomb_col.disabled = false
			collision_on = true
		if timer_move > 10:
			queue_free()
		if interp_alpha == 1:
			interp_alpha = 0

func _physics_process(_delta):
	var hit = move_and_collide(Vector3(0, 0, 0))
	if hit:
		if hit.collider.get_class() == "KinematicBody":
			if hit.collider.b_hittable:
				#print("hit")
				hit.collider.take_damage(damage)
