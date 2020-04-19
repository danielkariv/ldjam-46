extends Area
# Side to Side
export var bullet_instance : PackedScene = load("res://Enemy/Enemy Bullet.tscn")

var colddown : float
export var colddown_time : float = 0.33

var damage : int = 5 # self damage to player, not bullet!
var score_value = 150
var killed = false

var counter : float = 0
export var sin_speed = -8
func _ready():
	
	pass

func _physics_process(delta):
	# Need to figure out math for enemy movement, or just hack it together with animation..
	#translation += Vector3(sin(OS.get_ticks_msec()/100.0)/2,0,-cos(OS.get_ticks_msec()/100.0)/4)
	counter = fmod(counter + delta,2*PI)
	translation += Vector3(sin(counter)/sin_speed,0,0)
	# Shooting Input
	var is_fire = true
	if is_fire and colddown < 0:
		colddown = colddown_time
		var bi = bullet_instance.instance()
		bi.translation = translation
		get_parent().add_child(bi)
	
	colddown -= delta
	pass

func _on_HitArea_area_entered(area):
	if !killed:
		killed = true # added because sometimes there is double registering by 2 different bullets
		GameManager.add_score(score_value)
		area.queue_free()
		visible = false
		colddown = 10000
		$AudioStreamPlayer.play()
		yield(get_tree().create_timer(1.0), "timeout")
		queue_free()
	pass
