extends Enemy
signal invulActive

@export var bullet : PackedScene
@export var sword : Node2D
var hasRanged = false

	
const speed = 100
const cooldownSpeed = 20
const viewRange = 1000
const attackCooldownMelee = 0.5
const attackCooldownRanged = 2
const attackChargeupMelee = 0.5
const attackChargeupRanged = 1
const projectileRange = 400
const meleeRange = 50
const meleeDamage = 2
const keepDistance = 100
var maxHealth
var health = 1100

var aggro = 0
var attackIsReady = 0
var playerInRange = false
var phase = 1
var invulnerable = false

func _ready():
	getReady(get_node("."))
	$AnimatedSprite2D.play()
	maxHealth = health

func _process(delta):
	pass

func _physics_process(delta):
	if invulnerable:
		aggro = 0
	get_node("LookAtNode").look_at(player.position)
	sword.restingPos = get_node("LookAtNode").get_node("ReachNode").get_global_position()
	getMovement(get_node("."))

func _attackReady():
	if(attackIsReady == 1):
		attackIsReady = 2
	elif(attackIsReady == 3):
		attackIsReady = 4
	else:
		attackIsReady = 0

func hurtEnemy(dmg):
	if !invulnerable:
		health -= dmg
	
	if !sword.fireAllowed && health <= maxHealth*3/4 && phase == 1:
		$BarrierSound.play()
		phase = 2
		$AnimatedSprite2DBarrier.animation = "Active"
		invulnerable = true
		invulActive.emit()
		sword.fireAllowed = true
	if health <= maxHealth/2 && phase == 2:
		$BarrierSound.play()
		phase = 3
		$AnimatedSprite2DBarrier.animation = "Active"
		invulnerable = true
		invulActive.emit()
		hasRanged = true
	if health <= 0:
		sword.queue_free()

func _on_area_2d_body_entered(body):
	playerInRange = true

func _on_area_2d_body_exited(body):
	playerInRange = false

func invulBroken():
	$BarrierSound.stop()
	$AnimatedSprite2DBarrier.animation = "Deactive"
	invulnerable = false
