extends Node2D

@export var player : Node2D
@export var SkeletonTemplate : PackedScene

var aliveCrystals = 4
# Called when the node enters the scene tree for the first time.
func _ready():
	player.canAttack = true
	player.canRoll = true
	player.hasHammer = false
	player.hasSpear = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Player/CanvasLayer/Label.text = "Health: " + str(player.health)
	$Camera2D.global_position = player.position
	
	if(aliveCrystals == 0):
		aliveCrystals = -1
		$Barrier.queue_free()

func _on_area_2d_body_entered(body):
	get_tree().change_scene_to_file("res://Levels//fields.tscn")


func _on_timer_timeout():
	if($Player.position.x < 850 && $Player.position.y > 580):
		
		var skeleton = SkeletonTemplate.instantiate()
		skeleton.player = player
		skeleton.position.x = 606
		skeleton.position.y = 755
		get_tree().current_scene.add_child(skeleton)
		
		skeleton = SkeletonTemplate.instantiate()
		skeleton.player = player
		skeleton.position.x = 255
		skeleton.position.y = 528
		get_tree().current_scene.add_child(skeleton)
		
		skeleton = SkeletonTemplate.instantiate()
		skeleton.player = player
		skeleton.position.x = 240
		skeleton.position.y = 875
		get_tree().current_scene.add_child(skeleton)
		
	elif($Player.position.x > 850 && $Player.position.y > 580):
		var skeleton = SkeletonTemplate.instantiate()
		skeleton.player = player
		skeleton.position.x = 1344
		skeleton.position.y = 900
		get_tree().current_scene.add_child(skeleton)
		
		skeleton = SkeletonTemplate.instantiate()
		skeleton.player = player
		skeleton.position.x = 1054
		skeleton.position.y = 725
		get_tree().current_scene.add_child(skeleton)
		
	elif($Player.position.x < 850 && $Player.position.y < 580):
		var skeleton = SkeletonTemplate.instantiate()
		skeleton.player = player
		skeleton.position.x = 351
		skeleton.position.y = 262
		get_tree().current_scene.add_child(skeleton)
		
		skeleton = SkeletonTemplate.instantiate()
		skeleton.player = player
		skeleton.position.x = 255
		skeleton.position.y = 528
		get_tree().current_scene.add_child(skeleton)
		
	elif($Player.position.x > 850 && $Player.position.y < 580):
		var skeleton = SkeletonTemplate.instantiate()
		skeleton.player = player
		skeleton.position.x = 1231
		skeleton.position.y = 264
		get_tree().current_scene.add_child(skeleton)
		
		skeleton = SkeletonTemplate.instantiate()
		skeleton.player = player
		skeleton.position.x = 994
		skeleton.position.y = 341
		get_tree().current_scene.add_child(skeleton)
		
func _on_crystal_broken_crystal():
	aliveCrystals = aliveCrystals - 1
	$crystalbreak.play()

func _on_ambient_finished():
	$Camera2D/Ambient.play()

func _on_barrier_sound_finished():
	$Barrier/BarrierSound.play()
