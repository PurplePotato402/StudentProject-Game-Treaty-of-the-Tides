extends CharacterBody2D

var speed = 125
var target
var damage = 6

func _ready():
	look_at(target)

func _physics_process(delta):
	velocity = Vector2(speed, 0).rotated(rotation)
	position += velocity * delta
	move_and_slide()

func getDamage():
	return damage

func delete():
	queue_free()
