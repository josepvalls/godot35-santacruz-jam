extends Node2D

export var num_random := 500
export var num_homogeneous := 0
export var size_w := 2048
export var size_h := 2048
export var offset := Vector2.ZERO
export var color_range_lo := 0.2
export var color_range_hi := 0.4

var drawing = true

var leaves = []
const colors = [Color("756744"),Color("b79b4e"),Color("da5a5a"),Color("b7bd43"),Color("a27c1b")]
func _ready():
	leaves = $ViewportContainer/Viewport.get_children()
	
func _process(delta):
	if not drawing:
		return
	for leaf in leaves:
		leaf.position = Vector2(randf()*size_w*2, randf()*size_h*2)
		leaf.rotation = randf()*TAU
		var rand_brightness = rand_range(color_range_lo, color_range_hi)
		leaf.modulate = colors.pick_random() * rand_brightness
		leaf.modulate.a = 1.0
		
	num_random -= 1
	if num_random < 0:
		drawing = false
