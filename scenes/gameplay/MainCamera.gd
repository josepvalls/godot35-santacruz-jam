extends Camera2D

func _ready():
	position = get_viewport().size / 2

func _process(delta):
	# pass
	# static center of screen: just do nothing
	
	# static camera bias towards mouse
	# var offset = get_viewport().get_mouse_position() - get_viewport().size/2 + position
	# var target = (((get_viewport().size / 2) - offset) * 0.95) + offset
	# position = position.cubic_interpolate(target, position, target, 0.3)
	
	#position = get_viewport().size / 2
	
	# follow worm
	# position = $"../Worm/Head".position
	
	# bias towards mouse
	var offset = get_viewport().get_mouse_position() - get_viewport().size/2 + position
	var target = (($"../Worm/Head".position - offset) * 0.9) + offset
	position = position.cubic_interpolate(target, position, target, 0.3)
	
