extends Node
signal score_change
signal health_change

var health : int = 100
var score : int = 0

func _ready():
	# init UI
	emit_signal("health_change",health)
	emit_signal("score_change",score)
	pass

func add_score(amount):
	score += amount
	emit_signal("score_change",score)

func hit_health(amount):
	health = clamp(health-amount,0,100)
	emit_signal("health_change",health)

func player_died():
	# TODO: Do something after player died ( menu openning, restart level)
	pass
