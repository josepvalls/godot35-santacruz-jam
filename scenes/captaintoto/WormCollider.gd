class_name WormCollider

extends Area2D

export var width: float = 0.75

signal on_hit_self()
signal on_hit()

onready var shape: CollisionPolygon2D = $Shape

func build_collider(line: PoolVector2Array):
	# remove overlapping points from line because it prevents the polygon from being created right
	for i in line.size():
		while i > 0 and i < line.size() - 1:
			if line.size() == 1:
				break
			if line[i] == line[i - 1]:
				line.remove(i)
			else:
				break
			
	var result = Geometry.offset_polyline_2d(line, width)
	if result.size() > 1:
		emit_signal("on_hit_self")
	else:
		shape.polygon = PoolVector2Array(result[0])
	# for point in polygon:
	# 	print(point)
	
func _physics_process(delta):
	var areas = get_overlapping_areas()
	if areas.size() > 0:
		emit_signal("on_hit")
	
