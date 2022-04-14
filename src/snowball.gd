extends KinematicBody

# Declare member variables here. Examples:
var snowball_type: int
const SPEED: float = 8.0
var damage: float
var velocity = Vector3(SPEED, 0, 0)
var timer: float = 0
var b_hittable = false

func _init():
	pass
		
#  TYPES
# 0 = health giving
# 1 = super ball
# 2 = regular
func _ready():
	var randint = randi() % 20
	if randint == 0:
		damage = -10.0

	elif randint in [1, 2, 3]:
		damage = 20.0

	else:
		damage = 10.0
		
func _physics_process(delta):
	var hit = move_and_collide(velocity * delta)
	if hit:
		velocity = velocity.slide(hit.normal)
		if hit.collider.get_class() == "KinematicBody":
			if hit.collider.b_hittable:
				hit.collider.take_damage(damage)
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	if timer > 3:
		queue_free()
