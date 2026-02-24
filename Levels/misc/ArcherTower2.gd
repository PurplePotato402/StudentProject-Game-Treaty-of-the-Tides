extends StaticBody2D
var tower = 0
var health = 200
var maxHealth
signal archer2Down
# Called when the node enters the scene tree for the first time.
func _ready():
	maxHealth = health
	get_parent().towerCount = get_parent().towerCount + 1
	tower = get_parent().towerCount
	$Sprite2DStanding.visible = true
	$Sprite2DRuin.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _hit():
	health = health - 1
	
	if health <= maxHealth*0.1:
		$AnimatedSprite2D_Cracks.animation = "Crack5"
	elif health <= maxHealth*0.3:
		$AnimatedSprite2D_Cracks.animation = "Crack4"
	elif health <= maxHealth*0.5:
		$AnimatedSprite2D_Cracks.animation = "Crack3"
	elif health <= maxHealth*0.7:
		$AnimatedSprite2D_Cracks.animation = "Crack2"
	elif health <= maxHealth*0.9:
		$AnimatedSprite2D_Cracks.animation = "Crack1"
	if(health < 1):
		$AnimatedSprite2D_Cracks.animation = "Crack0"
		$towerCrumble.play()
		$Sprite2DStanding.visible = false
		$Sprite2DRuin.visible = true
		archer2Down.emit()
		
