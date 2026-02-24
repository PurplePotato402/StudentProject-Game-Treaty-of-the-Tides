extends Enemy

@export var bullet : PackedScene
var hasRanged = true

func _ready():
	getReady(get_node("."))
	$AnimatedSprite2D.play()
	
const speed = 10
const cooldownSpeed = 18
const viewRange = 2000
const attackCooldownMelee = 1
const attackCooldownRanged = 0.3
const attackChargeupMelee = 1
const attackChargeupRanged = 0.75
const projectileRange = 900
const meleeRange = 0
const meleeDamage = 0
const keepDistance = 0
var health = 100

var aggro = 1
var attackIsReady = 0
var playerInRange = false

func _process(delta):
	pass

func _physics_process(delta):
	getMovement(get_node("."))

func _attackReady():
	if(attackIsReady == 1):
		attackIsReady = 2
	elif(attackIsReady == 3):
		attackIsReady = 4
	else:
		attackIsReady = 0

func hurtEnemy(dmg):
	health -= dmg

func _on_area_2d_body_entered(body):
	playerInRange = true


func _on_area_2d_body_exited(body):
	playerInRange = false
