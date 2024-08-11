extends Area2D
class_name WormCollider

export var width: float = 10

signal on_hit_self()
signal on_hit()

onready var shape: CollisionPolygon2D = $Shape

func build_collider(line_: PoolVector2Array):
	var line = Array(line_)
	var result = null
	while not result:
		line = line.slice(0, len(line), 3)
		result = Geometry.offset_polyline_2d(line, width)
	if result.size() > 1:
		emit_signal("on_hit_self")
	shape.polygon = PoolVector2Array(result[0])
	
func _physics_process(delta):
	var areas = get_overlapping_areas()
	if areas.size() > 0:
		emit_signal("on_hit")
	
