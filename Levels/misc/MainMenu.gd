extends Node2D

func _ready():
	$Music.play()
	pass
		


func _on_start_pressed():
	get_tree().change_scene_to_file("res://Levels//beach.tscn")


func _on_quit_pressed():
	get_tree().quit()
