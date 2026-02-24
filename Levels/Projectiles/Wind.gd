extends CharacterBody2D

var speed = 200
var target
var damage = 5

func _ready():
	$AudioStreamPlayer2D.play()
	$AnimatedSprite2D.animation = "Creation"
	$AnimatedSprite2D.play()
	look_at(target)

func _physics_process(delta):
	if $AnimatedSprite2D.get_animation().match("Creation") && $AnimatedSprite2D.get_frame() == 5:
		$AnimatedSprite2D.animation = "Default"
		$AnimatedSprite2D.play()
	elif $AnimatedSprite2D.get_animation().match("Death") && $AnimatedSprite2D.get_frame() == 4:
		queue_free()
	velocity = Vector2(speed, 0).rotated(rotation)
	position += velocity * delta
	move_and_slide()

func getDamage():
	return damage

func delete():
	$CollisionShape2D.set_deferred("disabled", true)
	speed = 10
	$AnimatedSprite2D.animation = "Death"
	$AnimatedSprite2D.play()
