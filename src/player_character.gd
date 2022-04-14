extends KinematicBody

onready var anim := $snowman/AnimationPlayer
onready var gun := $snowman/char_grp/rig/Skeleton/BoneAttachment10/gun

const SPEED = 10.0
const JUMP_VELOCITY = 7.0
const GRAVITY = 9.86 * 2.0
var health: float = 100.0
var b_hittable = true
var b_shrink: bool
var scalar: float
var lerp_alpha: float = 0
var current_size: Vector3
var b_is_melting

# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var velocity = Vector3()


func _ready():
	gun.visible = false

func _process(_delta):
	if b_is_melting:
		take_damage(1)
	if b_shrink:
		_lerp_scale(current_size, Vector3(scalar, scalar, scalar))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
		if velocity.y > 0.0 and not anim.current_animation == "Jump":
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
	health -= damage
	health = clamp(health - damage, 0, 100)
	#print(health)
	# to increase min scale, increase first float below and change second float to 1 - first float  
	scalar = 0.3 + clamp(0.7 * (health / 100), 0, 1)
	current_size = $snowman.scale
	b_shrink = true
	if health <= 0:
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
