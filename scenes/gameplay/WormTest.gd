extends Node2D

var status_label: Label = null


var eating : String = "Nothing"
var eaten := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	status_label = $CanvasLayer/Label
	$Worm.start_position = get_viewport().size / 2
	$Worm.target = $PlayerTarget
	$Worm.connect("moved", self, "moved")
	$Enemy.target = $PlayerTarget
	$Enemy.speed = $Worm.speed / 2
	$Enemy2.target = $EnemyTarget
	$Enemy2.speed = $Worm.speed / 2
	call_deferred("reposition_enemy_target")

func reposition_enemy_target():
	$EnemyTarget.position = Vector2(get_viewport_rect().size.x * randf(), get_viewport_rect().size.y * randf())
	yield(get_tree().create_timer(2), "timeout")
	call_deferred("reposition_enemy_target")

func update_status():
	var status := ""
	status += "Eating: " + str(eating)
	status += "\n"
	status += "Eaten: " + str(eaten)
	status_label.text = status
	

func _process(delta):
	#var worm_head_position := $Worm/Head.position as Vector2
	#check_eating(worm_head_position)
	$PlayerTarget.position = get_viewport().get_mouse_position()
	update_status()
	
func moved(point: Vector2):
	check_eating(point)
	
func check_eating(point: Vector2):
	var eating_something = false
	for item_ in $Stuff.get_children():
		var item: Sprite = item_
		if item.get_rect().has_point(item.to_local(point)):
			if item.is_pixel_opaque(item.to_local(point)):
				eating = item.name
				var eaten_amount := item.modulate.r
				if eaten_amount > 0.0:
					eaten_amount = clamp(eaten_amount-.1, 0.0, 1.0)
					item.modulate = Color(eaten_amount,eaten_amount,eaten_amount,1.0)
					eating_something = true
					$Worm.max_len += 1
				else:
					eating_something = false
					eating = "Something decayed"
	if eating_something:
		eaten += 1
	else:
		eating = "Nothing"
				
	
