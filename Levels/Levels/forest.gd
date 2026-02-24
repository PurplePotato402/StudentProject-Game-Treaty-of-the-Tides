extends Node2D

@export var player : Node2D
@export var healthDisplay : Label
var tutorial = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	player.canAttack = true
	player.canRoll = false
	player.hasHammer = false
	player.hasSpear = false
	$Ambient.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Camera2D.global_position = player.position
	healthDisplay.text = "Health: " + str(player.health)
	if(!get_tree().root.get_node("Forest").has_node("Horse") and tutorial == 0):
		$PickupSound.play()
		player.canRoll = true
		tutorial = 1
		$Player/CanvasLayer/Tutorial.text = "SHIFT to dash"
	if(Input.is_action_just_pressed("roll") and tutorial == 1):
		$Player/CanvasLayer/Tutorial.text = "" 


func _on_next_level_body_entered(body):
	get_tree().change_scene_to_file("res://Levels//grave.tscn")

func _on_ambient_finished():
	$Ambient.play()
