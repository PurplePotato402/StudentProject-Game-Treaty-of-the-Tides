extends StaticBody2D

signal barrierBreak
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hurtEnemy(damage):
	barrierBreak.emit()
	queue_free()
