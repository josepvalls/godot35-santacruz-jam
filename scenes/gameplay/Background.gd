extends Node2D

export var num_random := 50
export var num_homogeneous := 0
export var size_w := 2048
export var size_h := 2048
export var offset := Vector2.ZERO
export var color_r_mult := 1.0
export var color_g_mult := 0.3
# Called when the node enters the scene tree for the first time.
func _ready():
	var leaves = $Leaves.get_children()
	for _i in num_random:
		var leaf = leaves[randi() % len(leaves)].duplicate()
		leaf.position = Vector2(randf()*size_w, randf()*size_h) - Vector2(size_w,size_h)/2 + offset
		leaf.rotation = randf()*PI*2
		leaf.modulate = Color(randf()*color_r_mult,randf()*color_g_mult,0.0)
		$Leaves.add_child(leaf)

	for _i in num_random:
		var leaf = leaves[randi() % len(leaves)].duplicate()
		leaf.position = Vector2(randf()*size_w/2, randf()*size_h/2) - Vector2(size_w,size_h)/4 + offset
		leaf.rotation = randf()*PI*2
		leaf.modulate = Color(randf()*color_r_mult,randf()*color_g_mult,0.0)
		$Leaves.add_child(leaf)


	for _i in num_homogeneous:
		var leaf = leaves[randi() % len(leaves)].duplicate()
		leaf.position = Vector2(1.0 * _i * size_w/num_homogeneous, 0) - Vector2(size_w,size_h)/2 + offset
		leaf.rotation = randf()*PI*2
		leaf.modulate = Color(randf()*color_r_mult,randf()*color_g_mult,0.0)
		$Leaves.add_child(leaf)
