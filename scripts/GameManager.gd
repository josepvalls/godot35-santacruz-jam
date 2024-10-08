extends Node

var player_reference: Worm = null
var player_target: Node2D = null
var stuff := {}
var current_level := 0
var current_score := 0
var next_level := "Level0"

func get_random_item(exclude_done: bool = true):
	var keys = stuff.keys()
	if exclude_done:
		var keys_ = Array(keys)
		for key in keys_:
			if stuff[key].done:
				keys.erase(key)
	if not keys:
		return null
	return stuff[keys[randi()%len(keys)]]
