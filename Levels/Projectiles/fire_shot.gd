extends CharacterBody2D

var speed = 200
var target
var damage = 10

func _ready():
	$AnimatedSprite2D.animation = "default"
	$AnimatedSprite2D.play()
	look_at(target)
	$fireWhoosh.play()

func _physics_process(delta):
	velocity = Vector2(speed, 0).rotated(rotation)
	position += velocity * delta
	move_and_slide()

func getDamage():
	return damage

func delete():
	queue_free()
