class_name WormCollider

extends Area2D

export var width: float = 0.75

signal on_hit_self()
signal on_hit()

onready var shape: CollisionPolygon2D = $Shape

var map = Dictionary()

func build_collider(line: PoolVector2Array):
	# result is an array of Array[Vector2]
	var result = Geometry.offset_polyline_2d(line, width)
	
	# if result is more than a single shape, then worm is overlapping itself
	if result.size() > 1:
		emit_signal("on_hit_self")
	else:
		# remove overlapping points from shape
		var path = Array()
		for i in result[0].size():
			if path.size() == 0 or path[path.size() - 1] != result[0][i]:
				path.append(result[0][i])
		
		# set collider shape
		shape.polygon = PoolVector2Array(path)
	
func _physics_process(_delta):
	var areas = get_overlapping_areas()
	if areas.size() > 0:
		emit_signal("on_hit")
	
