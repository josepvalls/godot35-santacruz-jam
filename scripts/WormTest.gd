extends Node2D

var status_label: Label = null


var eating : String = "Nothing"
var eaten := 0
var hit := 0
var hit_self := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	status_label = $CanvasLayer/Label
	$Worm.start_position = $PlayerPosition2D.position
	$Worm.target = $PlayerTarget
	$Worm.connect("moved", self, "moved")
	$Worm.connect("on_hit", self, "on_hit")
	$Worm.connect("on_hit_self", self, "on_hit_self")
	$Worm.start(true, false)
	
	$Enemy.target = $PlayerTarget
	$Enemy.start_position = get_viewport().size / 3
	$Enemy.speed = $Worm.speed / 2
	$Enemy.rotate_speed = $Worm.rotate_speed / 2
	$Enemy.start()
	$Enemy2.start_position = get_viewport().size / 3 * 2
	$Enemy2.target = $EnemyTarget
	$Enemy2.speed = $Worm.speed / 2
	$Enemy2.rotate_speed = $Worm.rotate_speed / 2
	$Enemy2.start()
	$Enemy3.start_position = get_viewport().size
	$Enemy3.target = $EnemyTarget
	$Enemy3.speed = $Worm.speed *2
	$Enemy3.rotate_speed = $Worm.rotate_speed * 2
	$Enemy3.start()
	call_deferred("reposition_enemy_target")

func on_hit_self():
	hit_self += 1
	
func on_hit():
	hit += 1
	

func reposition_enemy_target():
	$EnemyTarget.position = Vector2(get_viewport_rect().size.x * randf(), get_viewport_rect().size.y * randf())
	yield(get_tree().create_timer(2), "timeout")
	call_deferred("reposition_enemy_target")

func update_status():
	var status := ""
	status += "Eating: " + str(eating)
	status += "\n"
	status += "Eaten: " + str(eaten)
	status += "\n"
	status += "Self-hit: " + str(hit_self)
	status += "\n"
	status += "Hit: " + str(hit)

	status_label.text = status
	

func _process(delta):
	$PlayerTarget.position = get_viewport().get_mouse_position() - get_viewport().size/2 + $MainCamera.position
	update_status()
	
func moved(point: Vector2):
	if check_eating(point):
		$EatenViewport/EatenTrace.position = point
	
func check_eating(point: Vector2) -> bool:
	var eating_something = false
	# TODO check if we already ate here
	for item_ in $"%Stuff".get_children():
		var item: Sprite = item_
		if item.get_rect().has_point(item.to_local(point)):
			if item.is_pixel_opaque(item.to_local(point)):
				eating = item.name
				var eaten_amount := item.modulate.r
				if eaten_amount > 0.0:
					#eaten_amount = clamp(eaten_amount-.05, 0.0, 1.0)
					#item.modulate = Color(eaten_amount,eaten_amount,eaten_amount,1.0)
					eating_something = true
					$Worm.max_len += 1
				else:
					eating_something = true
					eating = "Something decayed"
	if eating_something:
		eaten += 1
	else:
		eating = "Nothing"
	return eating_something
				
	
