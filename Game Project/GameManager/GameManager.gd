extends Node
signal score_change
signal health_change

var health : int = 100
var score : int = 0
var combo : int = 0
func _ready():
	# init UI
	emit_signal("health_change",health)
	emit_signal("score_change",score)
	pass

func add_score(amount):
	combo += 1
	score += amount * combo
	emit_signal("score_change",score)

func hit_health(amount):
	health = clamp(health-amount,0,100)
	emit_signal("health_change",health)
	
	combo = 0

func player_died():
	# TODO: Do something after player died ( menu openning, restart level)
	pass
