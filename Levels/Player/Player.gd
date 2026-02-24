extends CharacterBody2D
signal OnFireSignal

const speed = 350.0
const rollTime = 0.25
const rollCooldown = 0.5
var rollReady = true
var controlable = true
var rollVelocity = Vector2.ZERO
var facing = "down"
var health = 100
var onFire = false

var canAttack
var canRoll
var hasHammer
var hasSpear

var dashDamage = 30
var dashing = false
var weapon = 0
var attackTimes = [0.5, 0.6, 0.4]
var attackAreas = [Vector2(80, 80), Vector2(120, 160), Vector2(160, 70)]
var attackDmgs = [50, 105, 30]
var hurt = []

func _ready():
	get_node("AttackArea/AnimatedSprite2D").animation = "SwordSlash"
	$AnimatedSprite2D.play()
	$AttackArea/AnimatedSprite2D.visible = false
	$AttackArea/AnimatedSprite2D.play()

func _physics_process(delta):
	var velocity = Vector2.ZERO
	if(controlable):
		if Input.is_action_pressed("move_left"):
			facing = "left"
			velocity.x -= 1
		if Input.is_action_pressed("move_right"):
			facing = "right"
			velocity.x += 1
		if Input.is_action_pressed("move_up"):
			facing = "up"
			velocity.y -= 1
		if Input.is_action_pressed("move_down"):
			facing = "down"
			velocity.y += 1
		
		if Input.is_action_pressed("weapon_1"):
			get_node("AttackArea/AnimatedSprite2D").animation = "SwordSlash"
			weapon = 0
		if Input.is_action_pressed("weapon_2") and hasHammer:
			get_node("AttackArea/AnimatedSprite2D").animation = "HammerSmash"
			weapon = 1
		if Input.is_action_pressed("weapon_3") and hasSpear:
			get_node("AttackArea/AnimatedSprite2D").animation = "SpearSlash"
			weapon = 2
		
		if Input.is_action_pressed("roll") and canRoll and rollReady:
			collision_mask = 41 #101001 for the masks
			dashing = true
			$dash.play()
			if velocity.length() > 0:
				rollVelocity = velocity
				velocity = Vector2.ZERO
			else:
				$AnimatedSprite2D.animation = "Dash"
				$AnimatedSprite2D.set_flip_h(false)
				match facing:
					"left":
						rollVelocity.x = -1
					"right":
						rollVelocity.x = 1
					"up":
						rollVelocity.y = -1
					"down":
						rollVelocity.y = 1
			controlable = false
			rollReady = false
			get_node("MovementTimer").start(rollTime)
		if Input.is_action_pressed("attack") and canAttack:
			$AttackArea/AnimatedSprite2D.visible = true
			match weapon:
				0:
					$SwordAttack.play()
				2: 
					$SpearAttack.play()
			#$attack.play()
			var shape = get_node("AttackArea/AttackShape")
			shape.position = Vector2.ZERO
			match facing:
				"left":
					shape.shape.size = attackAreas[weapon]
					get_node("AttackArea").position.x = -0.5 * attackAreas[weapon].x
					$AttackArea/AnimatedSprite2D.scale = attackAreas[weapon] / 500
					if weapon == 0:
						$AttackArea/AnimatedSprite2D.rotation_degrees = 135
					else:
						$AttackArea/AnimatedSprite2D.rotation_degrees = 180
					if weapon == 2:
						$AttackArea/AnimatedSprite2D.scale = attackAreas[weapon] / 400
					$AnimatedSprite2D.animation = "AttackRight"
					$AnimatedSprite2D.set_flip_h(true)
				"right":
					shape.shape.size = attackAreas[weapon]
					get_node("AttackArea").position.x = 0.5 * attackAreas[weapon].x
					$AttackArea/AnimatedSprite2D.scale = attackAreas[weapon] / 500
					if weapon == 0:
						$AttackArea/AnimatedSprite2D.rotation_degrees = 315
					else:
						$AttackArea/AnimatedSprite2D.rotation_degrees = 0
					if weapon == 2:
						$AttackArea/AnimatedSprite2D.scale = attackAreas[weapon] / 400
					$AnimatedSprite2D.animation = "AttackRight"
					$AnimatedSprite2D.set_flip_h(false)
				"up":
					shape.shape.size = Vector2(attackAreas[weapon].y, attackAreas[weapon].x)#swap the x & y sizes to rotate the area.
					get_node("AttackArea").position.y = -0.5 * attackAreas[weapon].x
					$AttackArea/AnimatedSprite2D.scale = attackAreas[weapon] / 500
					if weapon == 0:
						$AttackArea/AnimatedSprite2D.rotation_degrees = 225
					else:
						$AttackArea/AnimatedSprite2D.rotation_degrees = 270
					if weapon == 2:
						$AttackArea/AnimatedSprite2D.scale = attackAreas[weapon] / 400
					$AnimatedSprite2D.animation = "AttackUp"
				"down":
					shape.shape.size = Vector2(attackAreas[weapon].y, attackAreas[weapon].x)
					get_node("AttackArea").position.y = 0.5 * attackAreas[weapon].x
					$AttackArea/AnimatedSprite2D.scale = attackAreas[weapon] / 500
					if weapon == 0:
						$AttackArea/AnimatedSprite2D.rotation_degrees = 90
					else:
						$AttackArea/AnimatedSprite2D.rotation_degrees = 90
					if weapon == 2:
						$AttackArea/AnimatedSprite2D.scale = attackAreas[weapon] / 400
					$AnimatedSprite2D.animation = "AttackDown"
			$AttackArea/AnimatedSprite2D.play()
			if weapon == 1:
				shape.set_deferred("disabled", true)
			controlable = false
			velocity = Vector2.ZERO
			get_node("MovementTimer").start(attackTimes[weapon])
	else:
		velocity = Vector2.ZERO
		checkAttack()
	if velocity.length() > 0 && controlable and not ($AnimatedSprite2D.get_animation() == "Damaged" and $AnimatedSprite2D.get_frame() < 2):
		$AnimatedSprite2D.rotation_degrees = 0
		velocity = velocity.normalized() * speed
		position += velocity * delta
		
		if velocity.x > 0:
			$AnimatedSprite2D.animation = "Right"
			$AnimatedSprite2D.set_flip_h(false)
		elif velocity.x < 0:
			$AnimatedSprite2D.animation = "Right"
			$AnimatedSprite2D.set_flip_h(true)
		elif velocity.y > 0:
			$AnimatedSprite2D.animation = "Down"
		elif velocity.y < 0:
			$AnimatedSprite2D.animation = "Up"
		
	elif rollVelocity.length() > 0:
		rollVelocity = rollVelocity.normalized() * speed * 3
		position += rollVelocity * delta
		$AnimatedSprite2D.animation = "Dash"
		$AnimatedSprite2D.set_flip_h(false)
		$AnimatedSprite2D.rotation = rollVelocity.angle()
	elif controlable and not ($AnimatedSprite2D.get_animation() == "Damaged" and $AnimatedSprite2D.get_frame() < 2):
		$AnimatedSprite2D.rotation_degrees = 0
		$AnimatedSprite2D.animation = "Idle"
	checkProjectiles()
	move_and_slide()

func checkProjectiles():
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		if collision.get_collider() == null:
			continue
		if collision.get_collider().is_in_group("projectile"):
			velocity = Vector2.ZERO
			var proj = collision.get_collider()
			hurtPlayer(proj.getDamage())
			if collision.get_collider().is_in_group("Fireball"):
				onFire = true
				$FlameEffect.visible = true
				$FlameEffect.play("default")
				OnFireSignal.emit()
			proj.delete()
			break
		if collision.get_collider().is_in_group("meleeenemy"):
			velocity = Vector2.ZERO
			var proj = collision.get_collider()
			hurtPlayer(proj.getDamage())
			break

func checkAttack():
	for body in $AttackArea.get_overlapping_bodies():
		if(body.is_in_group("enemy") && !hurt.has(body)) && !body.is_in_group("smashable"):
			print("Damaging Enemy")
			if dashing: body.hurtEnemy(dashDamage)
			else: body.hurtEnemy(attackDmgs[weapon])
			hurt.append(body)
		if weapon == 1 and body.is_in_group("smashable") && !hurt.has(body):
			print("Destroying destructable via Hammer")
			if dashing: body.hurtEnemy(dashDamage)
			else: body.hurtEnemy(attackDmgs[weapon])
			hurt.append(body)
		if(body.is_in_group("crystal")): #for graves level
			body._break()
		if(body.is_in_group("tower")): #for town level
			body._hit()

func killPlayer():
	print("hello")
	$death.play()
	await get_tree().create_timer(0.85).timeout
	get_tree().reload_current_scene()

func hurtPlayer(dmg):
	if !onFire: $AnimatedSprite2D.animation = "Damaged"
	if(health > 0):
		health -= dmg
		if(health <= 0):
			killPlayer()

func setOnFire(fireDamage):
	onFire = true
	$FlameEffect.visible = true
	$FlameEffect.play("default")
	OnFireSignal.emit()

func _on_movement_timer_timeout():
	if weapon == 1 && get_node("AttackArea/AttackShape").is_disabled():
		$HammerAttack.play()
		get_node("AttackArea/AttackShape").set_deferred("disabled", false)
		get_node("MovementTimer").start(attackTimes[weapon])
	else:
		collision_mask = 57 #111001 for the masks
		$AttackArea/AnimatedSprite2D.visible = false
		hurt = []
		controlable = true
		
		rollVelocity = Vector2.ZERO
		dashing = false
		get_node("AttackArea").position = Vector2.ZERO
		get_node("AttackArea/AttackShape").position = Vector2.ZERO
		get_node("AttackArea/AttackShape").shape.size = Vector2.ZERO
	
	if not rollReady and get_node("CooldownTimer").is_stopped():
		get_node("CooldownTimer").start(rollCooldown)


func _on_cooldown_timer_timeout():
	rollReady = true
