extends Node2D

# To use. Attach a Node object to it.

@export var entity : PackedScene
@export var player : Node2D
@export var spawnPoint : Node2D
@export var spawnSpeed = 1
@export var spawnAmount = 1
@export var spawnOffset = 20
@export var wait = false
var spawnPosition

# Called when the node enters the scene tree for the first time.
func _ready():
	spawnPosition = spawnPoint.global_position
	get_node("Timer").start(spawnSpeed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	if !wait:
		for i in range(0, spawnAmount):
			var spawnedEntity = entity.instantiate()
			spawnedEntity.player = player
			spawnedEntity.position = spawnPosition + Vector2(-spawnAmount*spawnOffset/2 + i*spawnOffset, 0)
			spawnedEntity.aggro = 1
			get_tree().current_scene.add_child(spawnedEntity)

func hurtEnemy(damage):
	get_node("Timer").stop()
	queue_free()

func start():
	wait = false

func stop():
	wait = true
