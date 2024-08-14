extends Node2D
class_name Worm


export var max_len := 20
export var point_delta := 16
export var speed := 256
export var rotate_speed := PI * 4
export var follow_margin := 32
export var is_player := false
export var has_body := true
export var physics_based_movement := true
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
var immunity_timeout := 0.5
var immunity_elapsed := 0.0
var original_color := Color.white


signal moved(point)
signal on_hit()
signal on_hit_self()

# Called when the node enters the scene tree for the first time.
func _ready():
	head = $Head
	if has_body:
		body = $Body
		outline = $Outline
	if is_player:
		collider = $WormCollider
		if collider != null:
			collider.connect("on_hit_self", self, "on_hit_self")
			collider.connect("on_hit", self, "on_hit")
		GameManager.player_reference = self

func start(active_: bool = true, moving_: bool = true):
	head.position = position
	position = Vector2.ZERO
	body_points = [head.position]
	var radius := 0.0
	var delta := PI/2
	for i in max_len:
		radius += point_delta * 0.2
		delta += .6
		body_points.append(head.position + Vector2(cos(delta)*radius, sin(delta)*radius))
	if body:
		body.points = body_points
		outline.points = body_points
	active = active_
	moving = moving_
	original_color = modulate
	post_start()
	
func post_start():
	if not is_player:
		target = GameManager.player_target
		speed = speed / 2
		rotate_speed = rotate_speed / 2
	
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
			if body:
				var points := body_points.duplicate()
				if head.position.distance_to(body_points[0]) >= point_delta:
					if is_player:
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
					outline.points = points

				if collider != null:
					collider.build_collider(body.points)
	custom_physics(delta)
	
func custom_physics(delta):
	pass
	
func on_hit_self():
	emit_signal("on_hit_self")
	# moving = false
	# game_over()

func _process(delta):
	if immunity_elapsed > 0.0:
		immunity_elapsed -= delta
		var immunity_flash = clamp(immunity_elapsed/immunity_timeout, 0, 1)
		modulate = lerp(original_color, Color(1,0,0,1), immunity_flash)

func on_hit():
	if immunity_elapsed > 0.0:
		pass
	else:
		immunity_elapsed = immunity_timeout
		emit_signal("on_hit")
