extends Node2D


export var max_len := 10
export var point_delta := 32
export var speed := 256
export var follow_margin := 4

var head: Node2D = null
var body: Line2D = null
var body_points := []

# Called when the node enters the scene tree for the first time.
func _ready():
	body = $Body
	head = $Head
	head.position = get_viewport().size / 2
	body_points = [head.position]
	body.points = body_points


func _process(delta):
	var target = get_viewport().get_mouse_position()
	print(head.position.distance_to(target))
	if head.position.distance_to(target) >= follow_margin:
		head.position += head.position.direction_to(target) * speed * delta
		var points := body_points.duplicate()
		if head.position.distance_to(body_points[0]) >= point_delta:
			points.push_front(head.position)
			while len(points) > max_len:
				points.pop_back()
			body_points = points
			body.points = points
		else:
			points.push_front(head.position)
			body.points = points
				
