extends StaticBody2D
var alive = 1
signal brokenCrystal
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(".").add_to_group("crystal")


func _break():
	if(alive == 1):
		alive = 2
		visible = false
		brokenCrystal.emit()
		queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hurtEnemy(damage):
	_break()
