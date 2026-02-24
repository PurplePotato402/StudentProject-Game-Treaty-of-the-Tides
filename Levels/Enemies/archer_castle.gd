extends Enemy

@export var bullet : PackedScene
var hasRanged = true

func _ready():
	getReady(get_node("."))
	$AnimatedSprite2D.play()
	
const speed = 100
const cooldownSpeed = 20
const viewRange = 600
const attackCooldownMelee = 0
const attackCooldownRanged = 1.5
const attackChargeupMelee = 0
const attackChargeupRanged = 1.5
const projectileRange = 500
const meleeRange = 0
const meleeDamage = 0
const keepDistance = 100
var health = 100

var aggro = 0
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
