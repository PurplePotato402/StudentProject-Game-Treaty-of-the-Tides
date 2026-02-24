extends Node2D

@export var player : Node2D
@export var GuardTemplate : PackedScene

var towerCount = 0
var tower1up = 1
var tower2up = 1
var once = 1
var fireTickCount = 4

var storyStage = 0

# Called when the node enters the scene tree for the first time.@export var player : Node2D
func _ready():
	player.controlable = false
	player.canAttack = true
	player.canRoll = true
	player.hasHammer = true
	$Gate/AnimatedSprite2D.animation = "default"
	player.hasSpear = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Player/CanvasLayer/Label.text = "Health: " + str(player.health)
	if(storyStage == 0):
		$Camera2D.zoom = Vector2(2, 2)
		$Camera2D.position = player.position
		$Camera2D.position.y -= 500
		if Input.is_action_just_pressed("attack"):
			progressStory()
	elif(storyStage == 1):
		$Camera2D.position.y += (player.position.y - $Camera2D.position.y) * 0.5 * delta
		$Camera2D.zoom -= ($Camera2D.zoom - Vector2.ONE) * 0.8 * delta
		$Player/CanvasLayer/Story.modulate.a -= 0.001
		if($Camera2D.zoom.x - 1 < 0.05):
			progressStory()
	elif(storyStage == 2):
		$Camera2D.global_position = player.position
		$Camera2D.zoom = Vector2.ONE
		$Player/CanvasLayer/Label.visible = true
		$Player/CanvasLayer/HealthBar.visible = true
	_setArcherPos()
	if(tower1up == 2 && tower2up == 2 && once == 1):
		once = 2
		$Gate/AnimatedSprite2D.animation = "open"
		$Gate/Barrier.queue_free()
	
func _on_next_level_body_entered(body):
	get_tree().change_scene_to_file("res://Levels//castle_hallway.tscn")

func _on_spawn_timer_timeout():
	var guard = GuardTemplate.instantiate()
	guard.player = player
	guard.position.x = 585
	guard.position.y = 795
	get_tree().current_scene.add_child(guard)
	guard = GuardTemplate.instantiate()
	guard.player = player
	guard.position.x = 551
	guard.position.y = 474
	get_tree().current_scene.add_child(guard)
	guard = GuardTemplate.instantiate()
	guard.player = player
	guard.position.x = 1270
	guard.position.y = 809
	get_tree().current_scene.add_child(guard)
	guard = GuardTemplate.instantiate()
	guard.player = player
	guard.position.x = 1260
	guard.position.y = 500
	get_tree().current_scene.add_child(guard)
	
func _setArcherPos():
	if(tower1up == 1):
		$TowerArcher1.position.x = 705
		$TowerArcher1.position.y = 248
	if(tower2up == 1):
		$TowerArcher2.position.x = 1067
		$TowerArcher2.position.y = 252

func _on_archer_tower_archer_1_down():
	if(tower1up == 1):
		$TowerArcher1.queue_free()
		tower1up = 2

func _on_archer_tower_2_archer_2_down():
	if(tower2up == 1):
		$TowerArcher2.queue_free()
		tower2up = 2

func progressStory():
	storyStage += 1
	if(storyStage == 2):
		player.controlable = true
		$Player/CanvasLayer/Story.modulate.a = 0
		$SpawnTimer.start()


func _on_fire_tick_timer_timeout():
	if($Player.onFire == true):
		$Player.hurtPlayer(3)
		fireTickCount = fireTickCount - 1
		if(fireTickCount == 0):
			fireTickCount = 4
			$Player.onFire = false
			$Player/FlameEffect.visible = false


func _on_water_body_entered(body):
	$WaterSplashSound.play()
	fireTickCount = 4
	$Player.onFire = false
	$Player/FlameEffect.visible = false
