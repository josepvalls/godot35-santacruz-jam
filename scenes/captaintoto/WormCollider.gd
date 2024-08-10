class_name WormCollider

extends Area2D

export var width: float = 0.75

var hit_self = false

onready var shape: CollisionPolygon2D = $Shape

func build_collider(line: PoolVector2Array):
	var result = Geometry.offset_polyline_2d(line, width)
	hit_self = result.size() > 1
	if hit_self:
		print("hit self")
	shape.polygon = PoolVector2Array(result[0])
	# for point in polygon:
	# 	print(point)
	
func _physics_process(delta):
	var areas = get_overlapping_areas()
	if areas.size() > 0:
		print("colliding")
		emit_signal("OnHit")
	
