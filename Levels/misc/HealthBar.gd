extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var health = get_parent().get_parent().health
	if(health == 100):
		frame = 5
	elif(health < 100 && health >= 80):
		frame = 4
	elif(health < 80 && health >= 60):
		frame = 3
	elif(health < 60 && health >= 40):
		frame = 2
	elif(health < 40 && health >= 20):
		frame = 1
	else:
		frame = 0
