extends Area2D
class_name WormCollider

export var width: float = 10
export var update_freq: int = 1

var tick := 0

signal on_hit_self()
signal on_hit()

onready var shape: CollisionPolygon2D = $Shape

func build_collider(line_: PoolVector2Array):
	# if tick % update_freq != 0: return
	var line = Array(line_)
	
	# sub sample line points
	var result = null
	while not result:
		line = line.slice(0, len(line), 3)
		result = Geometry.offset_polyline_2d(line, width)
		
	if result.size() > 1:
		emit_signal("on_hit_self")
		
	# remove duplicates
	var path := Array()
	for point in result[0]:
		if path.size() == 0 or path[path.size() - 1] != point:
			path.append(point)
	shape.polygon = PoolVector2Array(path)
	
func _physics_process(delta):
	var areas = get_overlapping_areas()
	if areas.size() > 0:
		emit_signal("on_hit")
	tick += 1
	
