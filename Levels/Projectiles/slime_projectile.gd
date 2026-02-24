extends CharacterBody2D


const speed = 200
var target
var damage = 50

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
