extends CharacterBody2D

@export var player : Node2D
var speed = 150
var lunging = 0
var restingPos = Vector2.ZERO
var range = 300
var target = Vector2.ZERO
var damage = 30

func _ready():
	$AnimatedSprite2D.animation = "cooldown"
	restingPos = position

func _physics_process(delta):
	
	if(lunging == 0):
		look_at(player.position)
		if(position.distance_to(player.position) < range):
			target = player.position
			lunging = 1
			$AnimatedSprite2D.animation = "chargeup"
			$Chargeup.start(0.8)
	elif(lunging == 2 or lunging == 3):
		velocity.x = target.x - position.x
		velocity.y = target.y - position.y
		if(lunging == 3):
			velocity *= -1
		velocity = velocity * speed * delta
		if(position.distance_to(target) < 20):
			$AnimatedSprite2D.animation = "cooldown"
			lunging = 3
		if(position.distance_to(target) > restingPos.distance_to(target)):
			velocity = Vector2.ZERO
			position = restingPos
			lunging = 0
	
	move_and_slide()


func _on_chargeup_timeout():
	if(lunging == 1):
		lunging = 2


func _on_area_2d_body_entered(body):
	player.hurtPlayer(damage)

func delete():
	pass
