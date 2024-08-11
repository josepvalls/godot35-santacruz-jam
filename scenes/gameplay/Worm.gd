extends Node2D
class_name Worm


export var max_len := 20
export var point_delta := 16
export var speed := 256
export var rotate_speed := PI * 4
export var follow_margin := 32
export var is_player := false
export var physics_based_movement := false
export var momentum_based_movement := true

var start_position := Vector2.ZERO
var active := false
export var moving := false
var target: Node2D = null
var head: Node2D = null
var body: Line2D = null
var outline: Line2D = null
var collider: WormCollider = null
var body_points := []


signal moved(point)
signal on_hit()
signal on_hit_self()

# Called when the node enters the scene tree for the first time.
func _ready():
	body = $Body
	head = $Head
	outline = $Outline
	collider = $WormCollider
	if is_player and collider != null:
		collider.connect("on_hit_self", self, "on_hit_self")
		collider.connect("on_hit", self, "on_hit")

func start(active_: bool = true, moving_: bool = true):
	head.position = start_position
	body_points = [head.position]
	body.points = body_points
	active = active_
	moving = moving_
	
func _input(event):
	# trying to test the self-hit recovery
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT:
		moving = true




func _physics_process(delta):
	if active and target:
		var point = target.position
		var head_rotation = head.rotation
		head_rotation -= PI/2
		var target_rotation = null
		head.look_at(point)
		target_rotation = head.rotation
		var actual_rotation = move_toward(head_rotation, target_rotation, rotate_speed * delta)
		head.rotation = actual_rotation
		# this is just for looks until we fix the sprites to face right
		head.rotation += PI/2
		point = to_local(point)
		if moving and head.position.distance_to(point) >= follow_margin:
			if physics_based_movement:
				head.move_and_slide(Vector2.RIGHT.rotated(actual_rotation) * speed)
			else:
				if not momentum_based_movement:
					head.position += head.position.direction_to(point) * speed * delta
				else:
					head.position += Vector2.RIGHT.rotated(actual_rotation) * speed * delta
			var points := body_points.duplicate()
			if head.position.distance_to(body_points[0]) >= point_delta:
				emit_signal("moved", head.position)
				points.push_front(head.position)
				while len(points) > max_len:
					points.pop_back()
				body_points = points
				body.points = points
				outline.points = points
				
			else:
				points.push_front(head.position)
				body.points = points

	if collider != null:
		collider.build_collider(body.points)
	
func on_hit_self():
	emit_signal("on_hit_self")
	# moving = false
	# game_over()

func on_hit():
	emit_signal("on_hit")
	# game_over()


func game_over():
	get_tree().paused = true
	Game.change_scene("res://scenes/menu/menu.tscn", {
		'show_progress_bar': false
	})
