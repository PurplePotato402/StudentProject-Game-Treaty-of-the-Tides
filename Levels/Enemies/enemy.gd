extends CharacterBody2D

#Before adding an enemy:
#Note: This has all been done in this testing scene, but it will need to be done for each scene with enemies.
#In the TileMap node in the scene, expand the Navigation Layers menu on the right. Click Add Element.
#In the TileSet menu (found on the bottom), choose the paint option.
#Under paint Properties, select Navigation Layer Zero.
#Paint any tiles that the enemies will be able to walk on.

#How to make a new enemy
#In FileSystem in the bottom left, right click enemy.tscn.
#Select "New Inherited Scene"
#In the scene tree, you will see a characterbody 2D node named enemy, rename this to whatever you want the enemy to be called.
#You will also see yellow timer & navigation agent 2D nodes. Don't touch these.
#On the characterbody2D, add an animatedSprite2D node.
#Add animations called chargeup, cooldown, up, right, and down
#On the characterbody2D, add a collisionShape2D node.
#Make the shape to be whatever fits the enemy best.
#Attach a script to the characterBody2D node.
#Copy and paste the entire script of the fifth example. (The other ones work, but fifth is the most organized)
#If the enemy is not ranged, use comments to remove line 3, and set the variable hasRanged to false
#If the enemy is ranged, set hasRanged to true, and set a projectile scene as the PackedScene Bullet. (There is an example projectile to use, for some reason it won't damage the player yet.)
#Instantiate the enemy in the main level scene.
#On the right, under enemy, you will see a player field. drag & drop the player from the scene tree into this field.
#It should be working, let me know if there are any issues.

class_name Enemy

@export var player : Node2D
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D


func getReady(entity):
	entity.motion_mode = MOTION_MODE_FLOATING
	entity.wall_min_slide_angle = 0
	var cooldown = Timer.new()
	cooldown.name = "Cooldown"
	cooldown.timeout.connect(entity._attackReady)
	entity.add_child(cooldown)
	
	var meleeArea = Area2D.new()
	var collisionArea = CollisionShape2D.new()
	var circ = CircleShape2D.new()
	circ.radius = entity.meleeRange
	collisionArea.shape = circ
	meleeArea.add_child(collisionArea)
	meleeArea.body_entered.connect(entity._on_area_2d_body_entered)
	meleeArea.body_exited.connect(entity._on_area_2d_body_exited)
	meleeArea.collision_layer = 0
	meleeArea.collision_mask = 2
	entity.add_child(meleeArea)
	entity.add_to_group("enemy")

func getMovement(entity):
	entity.velocity = Vector2.ZERO
	if(entity.aggro == 1):
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		entity.velocity = dir * entity.speed
		if(entity.attackIsReady == 0):
			
			#decides which animation to play
			if(abs(entity.velocity.x) > abs(entity.velocity.y)):
				if(entity.velocity.x > 0):
					entity.get_node("AnimatedSprite2D").flip_h = false
					entity.get_node("AnimatedSprite2D").animation = "right"
				else:
					entity.get_node("AnimatedSprite2D").flip_h = true
					entity.get_node("AnimatedSprite2D").animation = "right"
			else:
				entity.get_node("AnimatedSprite2D").flip_h = false
				if(entity.velocity.y > 0):
					entity.get_node("AnimatedSprite2D").animation = "down"
				else:
					entity.get_node("AnimatedSprite2D").animation = "up"
			
			#begins a melee attack
			if(player.global_position.distance_to(entity.global_position) < entity.meleeRange):
				entity.get_node("AnimatedSprite2D").animation = "chargeup"
				entity.attackIsReady = 1
				entity.get_node("Cooldown").start(entity.attackChargeupMelee)
			#begins a ranged attack
			elif(entity.hasRanged and player.global_position.distance_to(entity.global_position) < entity.projectileRange):
				entity.get_node("AnimatedSprite2D").animation = "chargeup"
				entity.attackIsReady = 3
				entity.get_node("Cooldown").start(entity.attackChargeupRanged)
		#performs a melee attack
		elif(entity.attackIsReady == 2):
			if(entity.playerInRange):
				player.hurtPlayer(entity.meleeDamage)
			entity.attackIsReady = -1
			entity.get_node("Cooldown").start(entity.attackCooldownMelee)
		#performs a ranged attack
		elif(entity.attackIsReady == 4):
			entity.attackIsReady = -1
			entity.get_node("Cooldown").start(entity.attackCooldownRanged)
			var newProj = entity.bullet.instantiate()
			newProj.add_to_group("projectile")
			#newProj.global_position = global_position
			newProj.position = entity.position
			newProj.target = player.global_position
			#get_node("/root").add_child(newProj)
			#print(get_node("."))
			#get_node(".").add_child(newProj)
			get_tree().current_scene.add_child(newProj)
		#Completes an attack, begins cooldown
		elif(entity.attackIsReady == -1):
			entity.get_node("AnimatedSprite2D").animation = "cooldown"
			entity.velocity = dir * entity.cooldownSpeed
		if(player.global_position.distance_to(entity.global_position) < entity.keepDistance):
			entity.velocity *= -1
	else:
		if(player.global_position.distance_to(entity.global_position) < entity.viewRange):
			entity.aggro = 1
	entity.move_and_slide()
	if(entity.health <= 0):
		entity.queue_free()

func makePath():
	nav_agent.target_position = player.global_position


func _on_timer_timeout():
	makePath()
