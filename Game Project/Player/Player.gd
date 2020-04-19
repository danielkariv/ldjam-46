extends KinematicBody

export var bullet_instance : PackedScene 
export var invisible_mat : Material

var speed : float = 128.0
var drag : float = 128.0
var MAX_VELOCITY : float = 12.0
var direction : Vector3
var velocity : Vector3

var fire_colddown : float = 0.0
var fire_colddown_time : float = 0.1

var invisible_colddown : float = 0.0
var invisible_colddown_time : float = 1.0

func _ready():
	GameManager.connect("health_change",self,"_on_health_change")
	pass

func _process(delta):
	# Movement Input
	var axis_x = -Input.get_action_strength("player_left") + Input.get_action_strength("player_right")
	var axis_y = -Input.get_action_strength("player_up") + Input.get_action_strength("player_down")
	direction = Vector3(axis_x,0,axis_y).normalized()
	
	# Shooting Input
	var is_fire = Input.is_action_pressed("player_fire") 
	if is_fire and fire_colddown < 0:
		fire_colddown = fire_colddown_time
		var bi = bullet_instance.instance()
		bi.translation = translation
		get_parent().add_child(bi)
	fire_colddown -= delta
	
	# invisible countdown
	if invisible_colddown < 0:
		if $MeshInstance.material_override != null:
			$MeshInstance.material_override = null
	invisible_colddown -= delta
	pass

func _physics_process(delta):
	# Movement
	if direction.x == 0:
		velocity.x = move_toward(velocity.x,0,delta*drag)
	else:
		velocity.x = move_toward(velocity.x,velocity.x + direction.x*speed,delta*speed)
	$MeshInstance.rotation_degrees.z = clamp(velocity.x*2,-25,25)
	if direction.z == 0:
		velocity.z = move_toward(velocity.z,0,delta*drag)
	else:
		velocity.z = move_toward(velocity.z,velocity.z + direction.z*speed,delta*speed)
	$MeshInstance.rotation_degrees.x = clamp(-velocity.z*2,-5,15)
	velocity = Vector3(clamp(velocity.x,-MAX_VELOCITY,MAX_VELOCITY),
					clamp(velocity.y,-MAX_VELOCITY,MAX_VELOCITY),
					clamp(velocity.z,-MAX_VELOCITY,MAX_VELOCITY))
	
	velocity = move_and_slide(velocity)
	pass

func _on_HitArea_area_entered(area):
	if invisible_colddown < 0:
		GameManager.hit_health(area.damage)
		var random_sound = int(rand_range(1,3))
		$AudioStreamPlayer.stream = load("res://Sound/Hit_Hurt"+ String(random_sound)+".wav")
		$AudioStreamPlayer.play()
		invisible_colddown = invisible_colddown_time
		$MeshInstance.material_override = invisible_mat
	pass

func _on_health_change(amount):
	if amount == 0:
		GameManager.player_died()
		visible = false
		fire_colddown = 5000
		yield(get_tree().create_timer(1.0), "timeout")
		queue_free()
	pass


