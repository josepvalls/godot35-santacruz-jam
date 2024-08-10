extends Node2D
class_name Worm


export var max_len := 10
export var point_delta := 32
export var speed := 256
export var follow_margin := 4
export var is_player := false

var start_position := Vector2.ZERO
var target: Node2D = null
var head: Node2D = null
var body: Line2D = null
var collider: WormCollider = null
var body_points := []

signal moved(point)
signal on_hit()
signal on_hit_self()

# Called when the node enters the scene tree for the first time.
func _ready():
	body = $Body
	head = $Head
	collider = $WormCollider
	head.position = start_position
	body_points = [head.position]
	body.points = body_points
	if is_player and collider != null:
		collider.connect("on_hit_self", self, "on_hit_self")
		collider.connect("on_hit", self, "on_hit")


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
	if collider != null:
		collider.build_collider(body.points)
	
func on_hit_self():
	print("hit self")
	emit_signal("on_hit_self")
	# game_over()

func on_hit():
	print("hit")
	emit_signal("on_hit")
	# game_over()


func game_over():
	get_tree().paused = true
	Game.change_scene("res://scenes/menu/menu.tscn", {
		'show_progress_bar': false
	})
