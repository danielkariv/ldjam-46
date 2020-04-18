extends KinematicBody

# TODO: replace input [ui_XX] to custom ones 

export var bullet_instance : PackedScene 

var speed : float = 128.0
var drag : float = 64.0
var MAX_VELOCITY : float = 12.0
var direction : Vector3
var velocity : Vector3

var colddown : float
var colddown_time : float = 0.1
func _ready():
	pass
func _process(delta):
	# Movement Input
	var axis_x = -Input.get_action_strength("player_left") + Input.get_action_strength("player_right")
	var axis_y = -Input.get_action_strength("player_up") + Input.get_action_strength("player_down")
	direction = Vector3(axis_x,0,axis_y).normalized()
	
	# Shooting Input
	var is_fire = Input.is_action_pressed("player_fire") 
	if is_fire and colddown < 0:
		colddown = colddown_time
		var bi = bullet_instance.instance()
		bi.translation = translation
		get_parent().add_child(bi)
	
	colddown -= delta
	pass
func _physics_process(delta):
	# Movement
	if direction.x == 0:
		velocity.x = move_toward(velocity.x,0,delta*drag)
	else:
		velocity.x = move_toward(velocity.x,velocity.x + direction.x*speed,delta*speed)
	if direction.z == 0:
		velocity.z = move_toward(velocity.z,0,delta*drag)
	else:
		velocity.z = move_toward(velocity.z,velocity.z + direction.z*speed,delta*speed)
	
	velocity = Vector3(clamp(velocity.x,-MAX_VELOCITY,MAX_VELOCITY),
					clamp(velocity.y,-MAX_VELOCITY,MAX_VELOCITY),
					clamp(velocity.z,-MAX_VELOCITY,MAX_VELOCITY))
	#print(velocity)
	velocity = move_and_slide(velocity)
	pass
