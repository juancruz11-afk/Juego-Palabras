extends Node

var current_world: String = ""
var player_name: String = ""
var coins: int = 0

func goto_scene(path: String) -> void:
	get_tree().change_scene_to_file(path)

func add_coins(amount: int) -> void:
	coins += amount

func set_player_name(new_name: String) -> void:
	player_name = new_name