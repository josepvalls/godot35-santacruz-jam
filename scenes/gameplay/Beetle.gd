extends Worm
class_name Beetle

func post_start():
	target = GameManager.player_reference.head
	speed *= 0.5
	rotate_speed *= 0.1

func _process(delta):
	pass
	#if head.position.distance_to(target.position) < 256:
		#if head.rotation:
			


func custom_physics(delta):
	var r : RayCast2D = $Head/RayCast2D
	speed = 0
	if r.is_colliding():
		if r.get_collider().is_in_group("player_parts"):
			speed = 128
		
