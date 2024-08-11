extends Worm
class_name EnemyFly

var target_timeout := 0.0

func post_start():
	target = $TargetHint
	target.position = head.position

func _process(delta):
	if target:
		target.position += Vector2(randf()-0.5, randf()-0.5) * 100
		target_timeout -= delta
		if target_timeout <= 0:
			target_timeout = 2.0 + randf() * 2.0
			var tentative_target = null
			if randf()>0.4:
				if GameManager.stuff:
					tentative_target = GameManager.get_random_item()
			if tentative_target:
				target.position = tentative_target.position
			else:
				target.position = Vector2(randf()*get_viewport_rect().size.x, randf()*get_viewport_rect().size.y)
			
