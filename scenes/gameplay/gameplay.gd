extends Node

var elapsed = 0
var current_level = null

# `pre_start()` is called when a scene is loaded.
# Use this function to receive params from `Game.change_scene(params)`.
func pre_start(params):
	var cur_scene: Node = get_tree().current_scene
	print("Current scene is: ", cur_scene.name, " (", cur_scene.filename, ")")
	var scene = load("res://scenes/gameplay/levels/"+params["level"]+".tscn").instance()
	add_child(scene)
	current_level = scene
	print("Done")


# `start()` is called when the graphic transition ends.
func start():
	print("gameplay.gd: start() called")

