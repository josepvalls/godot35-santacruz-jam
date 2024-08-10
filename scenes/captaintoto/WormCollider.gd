extends CollisionPolygon2D


export var width: float = 0.75

var hit_self = false

func build_collider(line: PoolVector2Array):
	var result = Geometry.offset_polyline_2d(line, width)
	if result.size() > 1:
		hit_self = true
	polygon = PoolVector2Array(result[0])
	# for point in polygon:
	# 	print(point)
