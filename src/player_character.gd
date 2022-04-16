extends KinematicBody

onready var anim := $snowman/AnimationPlayer
onready var gun := $snowman/char_grp/rig/Skeleton/BoneAttachment10/gun
onready var hit_particles = $hit_particles
onready var hit_sfx = $hit_sfx
onready var coin_sfx = $coin_sfx
onready var jump_sfx = $jump_sfx
const snowball = preload("res://scenes/snowball.tscn")

const SPEED = 10.0
const JUMP_VELOCITY = 7.0
const GRAVITY = 9.86 * 2.0
var health: float = 100.0
var b_hittable = true
var b_shrink: bool
var b_is_invulnerable: bool
var b_is_firing: bool
var received_targets: Array
var timer: float
var scalar: float
var lerp_alpha: float = 0
var current_size: Vector3

# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var velocity = Vector3()


func _ready():
	gun.visible = false

func _process(_delta):
	if b_shrink:
		_lerp_scale(current_size, Vector3(scalar, scalar, scalar))
	if b_is_invulnerable:
		pass
		# add visual effects

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
		if velocity.y > 0.0 and not anim.current_animation == "Jump":
			jump_sfx.play()
			anim.play("Jump")
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	# Stop reverse
	#if input_dir.y > 0:
	#	input_dir.y = 0
	# Always move forwards
	input_dir.y = -1.0
	
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	var _a = move_and_slide(velocity, Vector3(0, 1, 0))
	
	if b_is_firing:
		# start timer
		timer += delta
		# fire once per 0.1 secs while target array is not empty
		if received_targets and timer > 0.1:
			# instantiate snowball at spawn point
			var new_snowball = snowball.instance()
			add_child(new_snowball)
			new_snowball.character_instance = true
			new_snowball.transform = $snowball_spawn.transform
			# set origin and target location
			var snowball_position = new_snowball.global_transform.origin
			var enemy_position = received_targets[0].global_transform.origin
			# change velocity towards target
			new_snowball.velocity = snowball_position.direction_to(enemy_position) * 2.0 * delta
			# trigger specific snowball behaviour
			new_snowball.b_find_enemy = true
			new_snowball.enemy_target = received_targets[0]
			# once fired at, remove target from array
			received_targets.remove(0)
			timer = 0
		# reset once all targets fired at
		elif !received_targets:
			timer = 0
			b_is_firing = false
			gun.visible = false
	
	global_transform.origin.x = clamp(global_transform.origin.x, -float(Globals.TRENCH_SIZE_X) / 2.0 + 0.5, float(Globals.TRENCH_SIZE_X) / 2.0 - 0.5)
	if global_transform.origin.z >= -1.0:
		global_transform.origin.z = -1.1
	
	if is_on_floor():
		# Handle Jump.
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = JUMP_VELOCITY
		elif velocity.z != 0.0:
			if not anim.current_animation == "Run":
				anim.play("Run")
		else:
			if not anim.current_animation == "Idle":
				anim.play("Idle")

func take_damage(damage):
	if !b_is_invulnerable:
		if damage > 0:
			hit_sfx.play()
			hit_particles.restart()
		else:
			coin_sfx.play()
		health -= damage
		health = clamp(health - damage, 0, 100)
		#print(health)
		# to increase min scale, increase first float below and change second float to 1 - first float  
		scalar = 0.3 + clamp(0.7 * (health / 100), 0, 1)
		current_size = $snowman.scale
		b_shrink = true
		if health <= 0:
			Globals.check_high_scores()
			Globals.gui.lose_screen.visible = true
			Globals.gui.play_again_btn.grab_focus()
			# handle game over
			queue_free()

func _lerp_scale(old_size, new_size):
	$snowman.scale = old_size.linear_interpolate(new_size, lerp_alpha)
	lerp_alpha = clamp(lerp_alpha + 0.05, 0, 1)
	if lerp_alpha == 1:
		lerp_alpha = 0
		b_shrink = false


func _on_melt_timer_timeout():
	take_damage(1)

func gunfire_PU(targets):
	# make gun visible and change bool to fire in process
	gun.visible = true
	received_targets = targets
	b_is_firing = true

