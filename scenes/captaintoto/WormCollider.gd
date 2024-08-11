class_name WormCollider

extends Area2D

export var width: float = 0.75

signal on_hit_self()
signal on_hit()

onready var shape: CollisionPolygon2D = $Shape

func build_collider(line: PoolVector2Array):
	# result is an array of Array[Vector2]
	var result = Geometry.offset_polyline_2d(line, width)
	
	# if result is more than a single shape, then worm is overlapping itself
	if result.size() > 1:
		emit_signal("on_hit_self")
	else:
		# remove overlapping points from shape
		for i in result[0].size():
			for j in range(i + 1, result[0].size()):
				if j >= result[0].size():
					break
				if (result[0][j] - result[0][i]).length() < 0.5:
					result[0].remove(j)
						
		# set collider shape, error happens here
		shape.polygon = PoolVector2Array(result[0])
	
func _physics_process(delta):
	var areas = get_overlapping_areas()
	if areas.size() > 0:
		emit_signal("on_hit")
	
