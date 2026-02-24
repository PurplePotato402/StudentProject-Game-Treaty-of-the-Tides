extends CharacterBody2D

@export var player : Node2D
@export var fireEntity : PackedScene

var speed = 150
var lunging = 0
var restingPos = Vector2.ZERO
var range = 200
var target = Vector2.ZERO
var damage = 5
var fire = false
var fireAllowed = false

var knockbackDuration = 1.5
var chargeupDuration = 0.5
var flyDuration = 0.3
var driftDuration = 1
var cooldownDuration = 2

func _ready():
	$AnimatedSprite2D.animation = "ready"

# -1Knockback 0ready 1Jump 2Attack 3Drift 4Return
func _physics_process(delta):
	if lunging == -1:
		velocity.x = target.x - position.x
		velocity.y = target.y - position.y
		velocity = -velocity * speed/2 * delta
	if (lunging == 0):
		look_at(player.position)
		if position.distance_to(player.position) < range && $Chargeup.is_stopped():
			$Chargeup.start(chargeupDuration)
			if fireAllowed: $AnimatedSprite2D.animation = "chargeupFire"
			else: $AnimatedSprite2D.animation = "chargeup"
			print("Preparing Lunge")
			look_at(player.position)
			target = player.position
		elif !$Chargeup.is_stopped():
			if fireAllowed: $AnimatedSprite2D.animation = "chargeupFire"
			else: $AnimatedSprite2D.animation = "chargeup"
			look_at(player.position)
			target = player.position
			velocity.x = restingPos.x - position.x
			velocity.y = restingPos.y - position.y
			velocity = velocity * speed/2 * delta
		else:
			if fireAllowed: $AnimatedSprite2D.animation = "readyFire"
			else: $AnimatedSprite2D.animation = "ready"
			velocity.x = restingPos.x - position.x
			velocity.y = restingPos.y - position.y
			velocity = velocity * speed * delta
	elif lunging == 2:
		velocity.x = target.x - position.x
		velocity.y = target.y - position.y
		velocity = velocity*2 * speed * delta
		if (position.distance_to(restingPos) > 100):
			if fireAllowed: $AnimatedSprite2D.animation = "driftingFire"
			else: $AnimatedSprite2D.animation = "drifting"
			print("floating")
			lunging = 3
			$Chargeup.start(driftDuration)
	elif lunging == 4:
		if fireAllowed: $AnimatedSprite2D.animation = "readyFire"
		else: $AnimatedSprite2D.animation = "ready"
		if fireAllowed: 
			fire = true
			damage = 2
		else :
			damage = 5
		velocity.x = restingPos.x - position.x
		velocity.y = restingPos.y - position.y
		velocity = velocity * speed * delta
		if $Chargeup.is_stopped():
			$Chargeup.start(cooldownDuration)
	
	if (lunging == 2 || lunging == 3) && fire && target.distance_to(position) < 40:
		fire = false
		var entity = fireEntity.instantiate()
		entity.player = player
		entity.position = target
		get_tree().current_scene.add_child(entity)
	move_and_slide()

func _on_chargeup_timeout():
	if lunging == -1:
		if fireAllowed: $AnimatedSprite2D.animation = "cooldownFire"
		else: $AnimatedSprite2D.animation = "cooldown"
		lunging = 4
	if lunging == 0:
		$DashSound.play()
		print("Lunging")
		lunging = 1
		$Chargeup.start(flyDuration)
	if lunging == 1:
		if fireAllowed: $AnimatedSprite2D.animation = "flyingFire"
		else: $AnimatedSprite2D.animation = "flying"
		print("Attacking")
		lunging = 2
	if lunging == 3:
		if fireAllowed: $AnimatedSprite2D.animation = "cooldownFire"
		else: $AnimatedSprite2D.animation = "cooldown"
		print("returning")
		lunging = 4
	elif lunging == 4:
		print("preparing")
		if fireAllowed: $AnimatedSprite2D.animation = "readyFire"
		else: $AnimatedSprite2D.animation = "ready"
		lunging = 0

func hurtEnemy(dmg):
	lunging = -1
	if fireAllowed: $AnimatedSprite2D.animation = "driftingFire"
	else: $AnimatedSprite2D.animation = "drifting"
	look_at(player.position)
	target = player.position
	$Chargeup.stop()
	$Chargeup.start(knockbackDuration)

func _on_area_2d_body_entered(body):
	player.hurtPlayer(damage)

func delete():
	pass
