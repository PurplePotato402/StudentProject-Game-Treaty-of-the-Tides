extends Node2D

@export var player : Node2D
# Called when the node enters the scene tree for the first time.
func _ready():
	player.canAttack = true
	player.canRoll = false
	player.hasHammer = false
	player.hasSpear = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Player/CanvasLayer/Label.text = "Health: " + str(player.health)


func _on_next_level_body_entered(body):
	get_tree().change_scene_to_file("res://Levels//forest.tscn")
