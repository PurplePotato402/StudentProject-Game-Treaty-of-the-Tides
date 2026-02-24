extends CharacterBody2D

@export var player: Node2D

const DAMAGE = 2
var speed = 150
var damage
var dashRange = 250
var dashCooldown = 0.4
var dashState = 1
var health = 50

var previousDistance = Vector2.ZERO

func _ready():
	damage = DAMAGE
	pass

func _physics_process(delta):
	if get_node("InvulTimer").is_stopped() && $CollisionShape2D.is_disabled():
		get_node("InvulTimer").start(dashCooldown/2)
	
	if position.distance_to(player.position) < dashRange+150 and (dashState == 0 or dashState == 1):
		$CollisionShape2D.set_deferred("disabled", false)
		$AnimatedSprite2D.animation = "Sitting"
		$AnimatedSprite2D.play()
		previousDistance = position.distance_to(player.position)
		look_at(player.position)
		velocity = Vector2(speed/100, 0).rotated(rotation)
		position += velocity * delta
		$crow.play()
	
	if position.distance_to(player.position) < dashRange && dashState >= 1:
		if previousDistance >= position.distance_to(player.position) + 100:
			dashState = 2
			look_at(player.position)
			get_node("DashTimer").start(dashCooldown)
		$AnimatedSprite2D.animation = "Dash"
		$AnimatedSprite2D.play()
		dashState = 2
		velocity = Vector2(speed, 0).rotated(rotation)
		position += velocity * delta
		if get_node("DashTimer").is_stopped():
			get_node("DashTimer").start(dashCooldown)
	elif dashState == 0:
		$CollisionShape2D.set_deferred("disabled", false)
		$AnimatedSprite2D.animation = "Default"
		$AnimatedSprite2D.play()
		velocity = Vector2.ZERO
	
	if dashState == 0 && get_node("DashTimer").is_stopped():
		get_node("DashTimer").start(dashCooldown*3)
	move_and_slide()

func getDamage():
	return damage

func hurtEnemy(damage):
	health -= damage
	if health <= 0:
		queue_free()

func delete():
	$CollisionShape2D.set_deferred("disabled", true)
	get_node("InvulTimer").start(dashCooldown/2)
	damage = 0



func _on_dash_timer_timeout():
	#$CollisionShape2D.set_deferred("disabled", false)
	if dashState == 2:
		dashState = 0
	else:
		dashState = 1


func _on_invul_timer_timeout():
	damage = DAMAGE
	$CollisionShape2D.set_deferred("disabled", false)
