extends StaticBody

onready var branches_nodes := $Branches

var branches: Array = []

func _ready():
	branches = branches_nodes.get_children()
	var n_empty_branches = Globals.rng.randi_range(1, Globals.TRENCH_SIZE_X - 1)
	for _i in range(0, n_empty_branches):
		var b_has_empty_branch: bool = false
		while not b_has_empty_branch:
			var n = Globals.rng.randi_range(0, branches.size() - 1)
			if branches[n].visible:
				b_has_empty_branch = true
				_hide_branch(n)
				
func _hide_branch(i):
	if branches[i]:
		branches[i].visible = false
		branches[i].get_node("CollisionShape").disabled = true

func is_blocked(x) -> bool:
	if branches[x].visible:
		return true
	return false
