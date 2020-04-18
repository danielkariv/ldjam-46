extends KinematicBody

var score_value = 100

func _ready():
	pass

func _physics_process(delta):
	# Need to figure out math for enemy movement, or just hack it together with animation..
	translation += Vector3(sin(OS.get_ticks_msec()/100.0)/2,0,-cos(OS.get_ticks_msec()/100.0)/4)
	pass

func _on_HitArea_area_entered(area):
	print(area.name)
	GameManager.add_score(score_value)
	area.queue_free()
	queue_free()
	
	
	pass # Replace with function body.
