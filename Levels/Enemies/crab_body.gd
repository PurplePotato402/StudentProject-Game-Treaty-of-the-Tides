extends CharacterBody2D

@export var health = 500
var maxHealth

@export var clawL : Node2D
@export var clawR : Node2D

func _ready():
	maxHealth = health
	clawL.get_node("AnimatedSprite2D").flip_v = true
	$AnimatedSprite2D.play

func hurtEnemy(dmg):
	if(health > 0):
		health -= dmg
		if(health <= 0):
			killCrab()
	if health <= maxHealth*0.1:
		$AnimatedSprite2D_Cracks.animation = "Crack5"
	elif health <= maxHealth*0.3:
		$AnimatedSprite2D_Cracks.animation = "Crack4"
	elif health <= maxHealth*0.5:
		$AnimatedSprite2D_Cracks.animation = "Crack3"
	elif health <= maxHealth*0.7:
		$AnimatedSprite2D_Cracks.animation = "Crack2"
	elif health <= maxHealth*0.9:
		$AnimatedSprite2D_Cracks.animation = "Crack1"

func killCrab():
	clawL.queue_free()
	clawR.queue_free()
	$Death.play()

func deleteCrab():
	queue_free()
