extends Node2D

@export var player : Node2D
@export var crystal : PackedScene
@export var archer : PackedScene
@export var warrior : PackedScene
var fireTickCount = 4
var storyStage = 0
var inWater = false
# Called when the node enters the scene tree for the first time.
func _ready():
	player.canAttack = true
	player.canRoll = true
	player.hasHammer = true
	player.hasSpear = true
	#$King.health = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Camera2D.global_position = player.position
	$Player/CanvasLayer/Label.text = "health: " + str(player.health)
	if(!get_tree().root.get_node("ThroneRoom").has_node("King") and storyStage == 0):
		$Player/CanvasLayer/Fadeout.modulate.a = 0.5
		$Player/CanvasLayer/Story.modulate.a = 1
		player.health = 10000
		storyStage = 1
		$Player/CanvasLayer/ButtonN.disabled = false
		$Player/CanvasLayer/ButtonN.modulate.a = 1
		$Player/CanvasLayer/ButtonO.disabled = false
		$Player/CanvasLayer/ButtonO.modulate.a = 1
	elif(storyStage == 1):
		player.controlable = false
	elif(storyStage == 2):
		$Player/CanvasLayer/Fadeout.modulate.a += 0.001
		if(Input.is_action_just_pressed("attack")):
			get_tree().change_scene_to_file("res://misc//main_menu.tscn")
	$Player/CanvasLayer/Label.text = "Health: " + str(player.health)

func _on_fire_tick_timer_timeout():
	if($Player.onFire == true):
		$Player.hurtPlayer(1)
		fireTickCount = fireTickCount - 1
		if(fireTickCount <= 0):
			fireTickCount = 4
			$Player.onFire = false
			$Player/FlameEffect.visible = false
		if inWater:
			$Sounds/WaterSplashSound.play()
			fireTickCount = 4
			$Player.onFire = false
			$Player/FlameEffect.visible = false


func _on_player_on_fire_signal():
	fireTickCount = 4


func _on_water_body_entered(body):
	inWater = true
	$Sounds/WaterSplashSound.play()
	fireTickCount = 4
	$Player.onFire = false
	$Player/FlameEffect.visible = false

func _on_water_body_exited(body):
	inWater = false

func _on_king_invul_active():
	$Sounds/CrystalCreationSound.play()
	var crystalEntity = crystal.instantiate()
	crystalEntity.position = $CrystalPoint.position
	crystalEntity.connect("brokenCrystal", Callable($King, "invulBroken"))
	get_tree().current_scene.add_child(crystalEntity)
	
	
	if $King.phase == 2:
		spawnEntity(warrior, Vector2($CrystalPoint.position.x - 500, $CrystalPoint.position.y))
		spawnEntity(warrior, Vector2($CrystalPoint.position.x + 500, $CrystalPoint.position.y))
		spawnEntity(warrior, Vector2($CrystalPoint.position.x - 250, $CrystalPoint.position.y))
		spawnEntity(warrior, Vector2($CrystalPoint.position.x + 250, $CrystalPoint.position.y))
		spawnEntity(archer, Vector2($CrystalPoint.position.x - 100, $CrystalPoint.position.y))
		spawnEntity(archer, Vector2($CrystalPoint.position.x + 100, $CrystalPoint.position.y))

func spawnEntity(entity, pos):
	var e = entity.instantiate()
	e.position = pos
	e.player = player
	get_tree().current_scene.add_child(e)


func _on_button_n_pressed():
	$Player/CanvasLayer/ButtonN.disabled = true
	$Player/CanvasLayer/ButtonN.modulate.a = 0
	$Player/CanvasLayer/ButtonO.disabled = true
	$Player/CanvasLayer/ButtonO.modulate.a = 0
	storyStage = 2
	$Player/CanvasLayer/Story.text = "Forced to listen to reason, the king comes to 
understand the need for a treaty. Generations of 
backwards progress, lives lost for nothing. You return 
to the sea, bringing with you a feeling of hope thought to 
have been lost."


func _on_button_o_pressed():
	$Player/CanvasLayer/ButtonN.disabled = true
	$Player/CanvasLayer/ButtonN.modulate.a = 0
	$Player/CanvasLayer/ButtonO.disabled = true
	$Player/CanvasLayer/ButtonO.modulate.a = 0
	storyStage = 2
	$Player/CanvasLayer/Story.text = "Seeing the king in this state, something dawns on you. 
you have completed that which was thought 
imposible. You alone have taken down your kingdom's 
greatest rival. Why bother with something as fragile as 
peace, when you can so easily take hold of absolute 
power? There is no need for treaties when all is under one rule."



func _on_audio_stream_player_2d_finished():
	$AudioStreamPlayer2D.play()
