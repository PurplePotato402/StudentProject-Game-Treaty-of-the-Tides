extends Area2D

var player
var damage = 2
var health = 120

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for body in get_overlapping_bodies():
		if $FireCooldown.is_stopped():
			player.setOnFire(damage)
			$FireCooldown.start()
	
	health -= 10*delta
	if health <= 0:
		queue_free()

func _on_body_entered(body):
	player.setOnFire(damage)
	$FireCooldown.start()

func _on_fire_cooldown_timeout():
	pass # Replace with function body.
