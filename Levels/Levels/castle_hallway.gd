extends Node2D

@export var player : Node2D
@export var spear : Node2D
@export var crystals = 0
var storyStage = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	player.canAttack = true
	player.canRoll = true
	player.hasHammer = true
	player.hasSpear = false
	#$Ambient.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Camera2D.global_position = player.position
	$Player/CanvasLayer/Label.text = "Health: " + str(player.health)
	
	if storyStage == 1 && Input.is_action_just_pressed("weapon_3"):
		$Player/CanvasLayer/Tutorial.text = ""
		storyStage = 2


func _on_next_level_body_entered(body):
	get_tree().change_scene_to_file("res://Levels//throne_room.tscn")


func _on_crystal_broken_crystal():
	crystals -= 1
	$crystalBreak.play()
	if crystals == 0:
		$Objects/Barrier.queue_free()


func _on_crystal_left_broken_crystal():
	$Objects/BarrierLeft.queue_free()
	$Objects/BarrierLeft2.queue_free()
	$Objects/BarrierLeft3.queue_free()
	$Objects/BarrierLeft4.queue_free()
	$crystalBreak.play()

func _on_crystal_right_broken_crystal():
	$Objects/BarrierRight.queue_free()
	$Objects/BarrierRight2.queue_free()
	$Objects/BarrierRight3.queue_free()
	$Objects/BarrierRight4.queue_free()
	$crystalBreak.play()

func _on_spear_pickup_body_entered(body):
	player.hasSpear = true
	$PickupSound.play()
	$Player/CanvasLayer/Tutorial.text = "Press 3 to equip the Spear"
	storyStage = 1
	spear.queue_free()

func _on_castle_barricade_barricade_break():
	$obstacleBreak.play()

func _on_castle_barricade_2_barricade_break():
	$obstacleBreak.play()


func _on_ambient_finished():
	$Ambient.play()
