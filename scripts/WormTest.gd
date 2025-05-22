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
var use_keyboard = false
var min_len := 3
var base_len := 20
export var next_level := "Level0"

# Called when the node enters the scene tree for the first time.
func _ready():
	status_label = $CanvasLayer/Label
	#$Worm.start_position = $Worm.position
	$Worm.target = $PlayerTarget
	$Worm.connect("moved", self, "moved")
	$Worm.connect("on_hit", self, "on_hit")
	$Worm.connect("on_hit_self", self, "on_hit_self")
	$Worm.start(true, false)
	
	
	for i in $Enemies.get_children():
		i.start()
	for i in $Flies.get_children():
		i.start()

	for item_ in $"%Stuff".get_children():
		var item: DecayItem = item_
		if item.material:
			item.material = item.material.duplicate()
		item.connect("decayed", self, "decayed")
		stuff_progress[item.name] = item
	GameManager.player_target = $PlayerTarget
	GameManager.stuff = stuff_progress
	GameManager.next_level = next_level
	GameManager.current_level += 1

func decayed(item: DecayItem):
	pass
	# feels better to increase on first bite instead
	#$Worm.max_len += 1

func on_hit_self():
	if is_playing:
		hit_self += 1
	
func on_hit():
	if is_playing:
		hit += 1
		$Worm.max_len -= 2
		if $Worm.max_len < min_len:
			print("game over")
			is_playing = false
			game_over()


func game_over():
	get_tree().paused = true
	Game.change_scene("res://scenes/menu/menu.tscn", {
		'show_progress_bar': false
	})


func update_status():
	var status := ""
	status += "Eating: " + str(eating)
	status += "\n"
	status += "Eaten: " + str(eaten)
	status += "\n"
	status += "Self-hit: " + str(hit_self)
	status += "\n"
	status += "Hit: " + str(hit)
	GameManager.current_score = eaten
	$HUD.update_health(100.0 * $Worm.max_len / (base_len + len(stuff_progress) * 2))
	$HUD.update_score(eaten)
	

func _process(delta):
	if is_playing:
		var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		if use_keyboard or direction != Vector2.ZERO:
			$PlayerTarget.position = $Worm/Head.position + direction * 1000
			use_keyboard = true
		else:
			$PlayerTarget.position = get_viewport().get_mouse_position() - get_viewport().size/2 + $MainCamera.position
		update_decaying(delta)
		update_status()
		update_sfx(delta)
		$MainCamera.position = $"Worm/Head".position
		

func _input(event):
	if is_playing:
		if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT:
			$Worm.moving = true
			use_keyboard = false
		elif event is InputEventKey and event.pressed: # and event.keycode == KEY_ESCAPE:
			$Worm.moving = true
			use_keyboard = true


	
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
	$Worm.active = false
	is_playing = false
	$LevelAdvanceMenu.finish_level()
			
		

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
		if stuff_progress[eating].bites==1:
			# first bite
			$Worm.max_len += 2
		eaten += 1
	else:
		eating = "Nothing"
	return eating_something
				
	
