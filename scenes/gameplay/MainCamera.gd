extends Camera2D

func _ready():
	position = get_viewport().size / 2

func _process(delta):
	pass
	position = $"../Worm/Head".position
	
