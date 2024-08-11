extends Node2D

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

func get_score() -> int: 
	# writeme
	return 0

func get_previous_level() -> int: 
	# writeme
	return 0

func _on_TextureButton_pressed() -> void:
	advance_level() 
