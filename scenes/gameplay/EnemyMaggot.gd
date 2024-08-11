extends Worm
class_name Maggot

var target_timeout := 0.0
var home_position := Vector2.ZERO

func post_start():
	target = $TargetHint
	target.position = head.position
	home_position = head.position

func _process(delta):
	if target:
		target.position += Vector2(randf()-0.5, randf()-0.5) * 100
		target_timeout -= delta
		if target_timeout <= 0:
			target.position = home_position
			target_timeout = 1.0
			
