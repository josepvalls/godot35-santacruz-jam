extends CanvasLayer

const LEVELCOMPLETE_STRING = "Level %d Complete!"
const TAGLINE_STRING = "Everything decayed away!"
const SCORE_STRING = "Score: %d"

func _ready():
	$VBoxContainer/Tagline.text = TAGLINE_STRING
	hide()
	

func finish_level() -> void: 
	show()
	$VBoxContainer/Score.text = SCORE_STRING % get_score()
	$VBoxContainer/LevelComplete.text = LEVELCOMPLETE_STRING % get_previous_level()
	# pause game 
	# alter global level var 

func advance_level() -> void: 
	# write me
	# unpause game
	hide()
	var params = {
		show_progress_bar = true,
		level = GameManager.next_level
	}
	Game.change_scene("res://scenes/gameplay/gameplay.tscn", params)

func get_score() -> int: 
	# writeme
	return GameManager.current_score

func get_previous_level() -> int: 
	# writeme
	return GameManager.current_level

func _on_TextureButton_pressed() -> void:
	advance_level() 
