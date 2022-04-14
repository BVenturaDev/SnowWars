extends Spatial

const red_tex := preload("res://assets/textures/snowman/M_Snowman_Base_color_RED.png")
const blue_tex := preload("res://assets/textures/snowman/M_Snowman_Base_color_BLUE.png")

onready var anim := $snowman/AnimationPlayer
onready var scarf_mesh = $snowman/char_grp/rig/Skeleton/BoneAttachment2/scarf
onready var loop_mesh = $snowman/char_grp/rig/Skeleton/BoneAttachment/loop
onready var helmet_mesh = $snowman/char_grp/rig/Skeleton/BoneAttachment7/helmet
onready var snowball_spawn = $snowball_spawn
onready var timer: float = 0
var b_red_team: bool
var new_snowball := preload("res://scenes/snowball.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	if b_red_team:
		var mat = scarf_mesh.mesh.surface_get_material(0).duplicate()
		mat.set_texture(0, red_tex)
		scarf_mesh.set_surface_material(0, mat)
		loop_mesh.set_surface_material(0, mat)
		helmet_mesh.set_surface_material(0, mat)
		rotation_degrees.y += 90.0
	else:
		var mat = scarf_mesh.mesh.surface_get_material(0).duplicate()
		mat.set_texture(0, blue_tex)
		scarf_mesh.set_surface_material(0, mat)
		loop_mesh.set_surface_material(0, mat)
		helmet_mesh.set_surface_material(0, mat)
		rotation_degrees.y -= 90.0


func _on_Timer_timeout():
	anim.animation_set_next("ShootGun", "IdleGun")
	anim.play("ShootGun")
	var spawn_trans = snowball_spawn.transform
	var snowball = new_snowball.instance()
	add_child(snowball)
	snowball.transform = spawn_trans
	if !b_red_team:
		snowball.velocity *= -1
