extends Worm
class_name Slug

var target_timeout := 0.0
var home_position := Vector2.ZERO

func post_start():
	target = $TargetHint
	target.position = head.position
	home_position = head.position

func _process(delta):
	if target:
		target.position += Vector2(randf()-0.5, randf()-0.5) * 50
		target_timeout -= delta
		if target_timeout <= 0:
			if randf() < 0.2:
				target.position = home_position
			else:
				var tentative_target = null
				if GameManager.stuff:
					tentative_target = GameManager.get_random_item()
				if tentative_target:
					target.position = tentative_target.position
				else:
					target.position = Vector2(randf()*get_viewport_rect().size.x, randf()*get_viewport_rect().size.y)
			target_timeout = 5.0
			
