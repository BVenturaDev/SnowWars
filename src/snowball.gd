extends KinematicBody

# Declare member variables here. Examples:
var snowball_type: int
const SPEED: float = 8.0
var damage: float
var velocity = Vector3(SPEED, 0, 0)
var timer: float = 0
var b_hittable = false
var b_character_instance: bool
var b_find_enemy: bool
var enemy_target
var randint: int

func _init():
	randint = randi() % 20
		
#  TYPES
# 0 = health giving
# 1 = super ball
# 2 = regular
func _ready():
	if randint == 0:
		damage = -10.0

	elif randint in [1, 2, 3]:
		damage = 20.0

	else:
		damage = 10.0
		
func _physics_process(delta):
	var _hit = move_and_collide(velocity * delta)
	#if hit:
	#	if !b_character_instance:
	#		velocity = velocity.slide(hit.normal)
	#		if hit.collider.get_class() == "KinematicBody":
	#			if hit.collider.b_hittable:
	#				hit.collider.take_damage(damage)
	#		queue_free()
	
	# once snowball reaches enemy location, despawn enemy and snowball
	if b_find_enemy:
		if translation == enemy_target.translation:
			print("HIT ENEMY")
			enemy_target.queue_free()
			queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	if timer > 3:
		queue_free()


func _on_Area_body_entered(body):
	if body == Globals.character:
		body.take_damage(damage)
		queue_free()
