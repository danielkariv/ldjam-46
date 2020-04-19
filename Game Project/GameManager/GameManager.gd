extends Node
signal score_change
signal health_change
signal player_died
var debug_mode : bool = false
var check_if_enemies_alive_timer : Timer

var health : int = 100
var score : int = 0
var combo : int = 0

var lvl : int = -1
var lvl_max : int = 4
var lvl_node : Spatial = null
var damage_mul : float = 1
func _ready():
	
	# init UI
	emit_signal("health_change",health)
	emit_signal("score_change",score)
	# init level
	if debug_mode == false:
		load_next_level()
	
	check_if_enemies_alive_timer = Timer.new()
	check_if_enemies_alive_timer.wait_time = 3
	check_if_enemies_alive_timer.autostart = true
	check_if_enemies_alive_timer.name = "Enemies Check Timer"
	add_child(check_if_enemies_alive_timer)
	check_if_enemies_alive_timer.connect("timeout",self,"_on_enemies_checker_timeout")
	pass

func _input(event):
	if event.is_action_pressed("player_restart"):
		health = 100
		score = 0
		combo = 0
		lvl = -1
		lvl_node = null
		damage_mul = 1
		get_tree().reload_current_scene()
		pass

func add_score(amount):
	combo += 1
	score += amount * combo
	emit_signal("score_change",score)
	
	

func hit_health(amount):
	combo = 0
	health = clamp(health-amount*damage_mul,0,100)
	emit_signal("health_change",health)
	
	

func player_died():
	emit_signal("player_died")
	# TODO: Do something after player died ( menu openning, restart level)
	pass

func load_next_level():
	if fmod(lvl+1,lvl_max+1) < lvl:
		damage_mul = damage_mul * 1.2
	lvl = fmod(lvl+1,lvl_max+1)
	if lvl == 0:
		lvl = 1
	lvl_node = load("res://Levels/Level" + String(lvl)+".tscn").instance()
	var scene_root = get_node("/root/Spatial")
	if scene_root != null and lvl_node != null:
		scene_root.add_child(lvl_node)
	print(lvl)

func _on_enemies_checker_timeout():
	if lvl_node != null:
		if lvl_node.get_child_count() == 0 and debug_mode == false:
			load_next_level()
	else:
		if debug_mode == false:
			load_next_level()
