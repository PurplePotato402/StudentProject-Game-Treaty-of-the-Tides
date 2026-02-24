extends CharacterBody2D

@export var player: Node2D

const DAMAGE = 2
var speed = 300
var damage
var dashRange = 200
var dashCooldown = 0.5
var dashState = 1
var health = 101

var previousDistance = Vector2.ZERO

func _ready():
	damage = DAMAGE
	pass

func _physics_process(delta):
	if get_node("InvulTimer").is_stopped() && $CollisionShape2D.is_disabled():
		get_node("InvulTimer").start(dashCooldown/5)
	
	if position.distance_to(player.position) < dashRange+50 and (dashState == 0 or dashState == 1):
		$CollisionShape2D.set_deferred("disabled", false)
		$AnimatedSprite2D.animation = "Default"
		$AnimatedSprite2D.play()
		previousDistance = position.distance_to(player.position)
		look_at(player.position)
	
	if position.distance_to(player.position) < dashRange && dashState >= 1:
		$AnimatedSprite2D.animation = "Dash"
		$AnimatedSprite2D.play()
		dashState = 2
		velocity = Vector2(speed, 0).rotated(rotation)
		if get_node("DashTimer").is_stopped():
			get_node("DashTimer").start(dashCooldown)
			$DashSound.play()
	elif dashState == 0:
		$CollisionShape2D.set_deferred("disabled", false)
		$AnimatedSprite2D.animation = "Default"
		$AnimatedSprite2D.play()
		velocity = Vector2.ZERO
	
	if dashState == 0 && get_node("DashTimer").is_stopped():
		get_node("DashTimer").start(dashCooldown*3)
	
	var body = move_and_collide(velocity*2*delta)
	if body != null and body.get_collider() != null and body.get_collider().is_in_group("player"):
		$CollisionShape2D.set_deferred("disabled", true)
		get_node("InvulTimer").start(dashCooldown/5)
		body.hurtPlayer(damage)

func getDamage():
	return damage

func hurtEnemy(damage):
	health -= damage
	if health <= 0:
		queue_free()

func delete():
	$CollisionShape2D.set_deferred("disabled", true)
	get_node("InvulTimer").start(dashCooldown/5)
	if damage == DAMAGE:
		damage = 2 
	elif damage < DAMAGE and damage > 0:
		damage -= 1



func _on_dash_timer_timeout():
	$CollisionShape2D.set_deferred("disabled", false)
	if dashState == 2:
		dashState = 0
	else:
		dashState = 1


func _on_invul_timer_timeout():
	damage = DAMAGE
	$CollisionShape2D.set_deferred("disabled", false)
