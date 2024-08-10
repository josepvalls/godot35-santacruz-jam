extends Node2D
class_name Worm


export var max_len := 10
export var point_delta := 32
export var speed := 256
export var follow_margin := 4

var start_position := Vector2.ZERO
var target: Node2D = null
var head: Node2D = null
var body: Line2D = null
onready var collider: WormCollider = $WormCollider
var body_points := []

signal moved(point)

# Called when the node enters the scene tree for the first time.
func _ready():
	body = $Body
	head = $Head
	head.position = start_position
	body_points = [head.position]
	body.points = body_points


func _process(delta):
	if target:
		var point = target.position
		head.look_at(point)
		head.rotation += PI/2
		point = to_local(point)
		if head.position.distance_to(point) >= follow_margin:
			head.position += head.position.direction_to(point) * speed * delta
			var points := body_points.duplicate()
			if head.position.distance_to(body_points[0]) >= point_delta:
				emit_signal("moved", head.position)
				points.push_front(head.position)
				while len(points) > max_len:
					points.pop_back()
				body_points = points
				body.points = points
			else:
				points.push_front(head.position)
				body.points = points

func _physics_process(delta):
	collider.build_collider(body.points)
