extends Node2D

@export var player : Node2D
@export var hammer : Node2D
var storyStage = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	player.canAttack = true
	player.canRoll = true
	player.hasHammer = false
	player.hasSpear = false
	$Ambient.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Camera2D.global_position = player.position
	$Player/CanvasLayer/Label.text = "Health: " + str(player.health)
	
	if storyStage == 1 && Input.is_action_just_pressed("weapon_2"):
		$Player/CanvasLayer/Tutorial.text = "Press 1 to switch back to the sword"
		storyStage = 2
	if storyStage == 2 && Input.is_action_just_pressed("weapon_1"):
		$Player/CanvasLayer/Tutorial.text = ""
		storyStage = 3

func _on_next_level_body_entered(body):
	get_tree().change_scene_to_file("res://Levels//town.tscn")

func _on_hammer_body_entered(body):
	player.hasHammer = true
	$PickupSound.play()
	$Player/CanvasLayer/Tutorial.text = "Press 2 to equip the Hammer"
	storyStage = 1
	hammer.queue_free()

func _on_town_gate_barrier_break():
	$barrierBreak.play()


func _on_ambient_finished():
	$Ambient.play()
