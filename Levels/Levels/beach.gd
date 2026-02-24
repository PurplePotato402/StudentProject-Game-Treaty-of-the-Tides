extends Node2D

@export var player : Node2D
@export var sword : Node2D
var storyStage = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	player.canAttack = false
	player.canRoll = false
	player.hasHammer = false
	player.hasSpear = false
	player.controlable = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Player/CanvasLayer/Label.text = "Health: " + str(player.health)
	if(storyStage == 0):
		$Camera2D.position = player.position
		$Camera2D.position.y += 1000
		if Input.is_action_just_pressed("attack"):
			progressStory()
	elif (storyStage == 1):
		#$Camera2D.position.y += (player.position.y - $Camera2D.position.y - 225) * 0.5 * delta
		$Camera2D.position.y += (1356 - $Camera2D.position.y) * 0.5 * delta
		$Camera2D/Label.modulate.a -= 0.001
		if($Camera2D.position.y - 1376 < 20):
			progressStory()
	elif(storyStage == 2):
		$Player/CanvasLayer/Label.modulate.a = 1
		$Player/CanvasLayer/HealthBar.visible = true
		$Camera2D.position = player.position
		if(Input.is_action_just_pressed("move_up")):
			$Player/CanvasLayer/Tutorial.text = ""
	elif(storyStage == 3):
		$Camera2D.position = player.position
		if Input.is_action_just_pressed("attack"):
			$Player/CanvasLayer/Tutorial.text = ""


func progressStory():
	storyStage += 1
	if(storyStage == 2):
		$Player/CanvasLayer/Tutorial.text = "WASD to move"
		player.controlable = true
		$Camera2D/Label.modulate.a = 0
		$Camera2D.limit_bottom = 1700

func _on_next_level_body_entered(body):
	get_tree().change_scene_to_file("res://Levels//rocks.tscn")


func _on_sword_body_entered(body):
	storyStage = 3
	$PickupSound.play()
	$Player/CanvasLayer/Tutorial.text = "SPACE to attack"
	player.canAttack = true
	sword.queue_free()

func _on_ambient_finished():
	$Ambient.play()

func _on_beach_barrier_barrier_break():
	$barrierBreak.play()
