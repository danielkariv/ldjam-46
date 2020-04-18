extends Node
signal score_change

var score : int = 0
func _ready():
	
	pass

func add_score(amount):
	score += amount
	emit_signal("score_change",score)
