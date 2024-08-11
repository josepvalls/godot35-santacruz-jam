extends Node2D

var status_label: Label = null
var sfx_eating: AudioStream = preload("res://assets/sfx/sfx_eating3.wav")
var sfx_walking: AudioStream = preload("res://assets/sfx/sfx_movement6(slow).wav")
var sfx_playback_timeout := 0.4
var sfx_playback_elapsed := 0.0
var sfx_playback_deadline := 0.0

var is_playing := true
var eating : String = "Nothing"
var eaten := 0
var hit := 0
var hit_self := 0
var stuff_progress = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	status_label = $CanvasLayer/Label
	#$Worm.start_position = $Worm.position
	$Worm.target = $PlayerTarget
	$Worm.connect("moved", self, "moved")
	$Worm.connect("on_hit", self, "on_hit")
	$Worm.connect("on_hit_self", self, "on_hit_self")
	$Worm.start(true, false)
	GameManager.player_reference = $Worm
	
	$Enemy.target = $PlayerTarget
	#$Enemy.start_position = $Worm.start_position - Vector2.LEFT * 60
	$Enemy.speed = $Worm.speed / 2
	$Enemy.rotate_speed = $Worm.rotate_speed / 2
	$Enemy.start()
	#$Enemy2.start_position = $Worm.start_position - Vector2.LEFT * 120
	$Enemy2.target = $EnemyTarget
	$Enemy2.speed = $Worm.speed / 2
	$Enemy2.rotate_speed = $Worm.rotate_speed / 2
	$Enemy2.start()
	#$Enemy3.start_position = $Worm.start_position - Vector2.UP * 60
	$Enemy3.target = $EnemyTarget
	$Enemy3.speed = $Worm.speed *2
	$Enemy3.rotate_speed = $Worm.rotate_speed * 2
	$Enemy3.start()
	$Beetle.target = $PlayerTarget
	$Beetle.speed = 0
	$Beetle.rotate_speed = $Worm.rotate_speed / 16
	$Beetle.start()
	$Beetle2.target = $PlayerTarget
	$Beetle2.speed = 0
	$Beetle2.rotate_speed = $Worm.rotate_speed / 16
	$Beetle2.start()


	for item_ in $"%Stuff".get_children():
		var item: DecayItem = item_
		if item.material:
			item.material = item.material.duplicate()
		stuff_progress[item.name] = item
		
	
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
	if is_playing:
		$PlayerTarget.position = get_viewport().get_mouse_position() - get_viewport().size/2 + $MainCamera.position
		update_decaying(delta)
		update_status()
		update_sfx(delta)
	
func update_sfx(delta):
	sfx_playback_elapsed += delta
	if sfx_playback_elapsed >= sfx_playback_deadline:
		$SFXPlayer.stop()

func update_decaying(delta):
	var done_count := 0
	for item_ in stuff_progress:
		var item: DecayItem = stuff_progress[item_]
		if item.done:
			done_count += 1
	if done_count == len(stuff_progress):
		done_state()
		
func done_state():
	$SFXPlayer.stop()
	$EventPlayer.play()
	$CanvasLayer/Done/Label.text = "Cool, you decomposed it all. Yay decay!\nYour score is: " + str(eaten)
	$CanvasLayer/Done.show()
	$Worm.active = false
	is_playing = false
	
			
		

func moved(point: Vector2):
	if check_eating(point):
		$EatenViewport/EatenTrace.position = point
		if not $SFXPlayer.playing or $SFXPlayer.stream != sfx_eating and sfx_playback_elapsed > sfx_playback_timeout:
			$SFXPlayer.stream = sfx_eating
			$SFXPlayer.play()
	else:
		if not $SFXPlayer.playing or $SFXPlayer.stream != sfx_walking and sfx_playback_elapsed > sfx_playback_timeout:
			$SFXPlayer.stream = sfx_walking
			$SFXPlayer.play()
	sfx_playback_deadline = sfx_playback_elapsed + sfx_playback_timeout
		
	
func check_eating(point: Vector2) -> bool:
	var eating_something = false
	# TODO check if we already ate here
	for item_ in stuff_progress:
		var item: DecayItem = stuff_progress[item_]
		if item.get_rect().has_point(item.to_local(point)):
			if item.is_pixel_opaque(item.to_local(point)):
				eating = item.name
				if not item.done:
					eating_something = true
					#$Worm.max_len += 1
				else:
					eating_something = false
					eating = "Something decayed"
	if eating_something:
		stuff_progress[eating].bites += 1
		eaten += 1
	else:
		eating = "Nothing"
	return eating_something
				
	
