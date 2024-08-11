extends Sprite
class_name DecayItem

export var start_decay_bites := 1
export var start_decay_timeout := 1.0
export var decay_rate := 0.20

var bites := 0
var elapsed := 0.0
var decay := 0.0
var done := false

func _process(delta):
	if not done:
		if bites >= start_decay_bites:
			elapsed += delta
			if elapsed >= start_decay_timeout:
				decay += delta * decay_rate				
				if material:
					material.set_shader_param("percentage", 1.0 - decay)

				if decay >= 1.0:
					decay = 1.0
					done = true
		else:
			var new_scale = 1 + (sin(Time.get_unix_time_from_system() * 1.6) * 0.012)
			scale = Vector2(new_scale, new_scale)
