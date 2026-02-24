extends Enemy

#@export var bullet : PackedScene
var hasRanged = false

func _ready():
	getReady(get_node("."))
	$AnimatedSprite2D.play()
	
const speed = 140
const cooldownSpeed = 20
const viewRange = 300
const attackCooldownMelee = 1
const attackCooldownRanged = 1.5
const attackChargeupMelee = 0.5
const attackChargeupRanged = 1.5
const projectileRange = 200
const meleeRange = 60
const meleeDamage = 5
const keepDistance = 0
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
