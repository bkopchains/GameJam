extends CharacterBody2D


const SPEED = 200.0
const MAXSPEED = 200.0
const JUMP_VELOCITY = -400.0
const MAX_FALL_SPEED = 400
@export var ACCELERATION=500
var fireball = null
@onready var anim = $Sprite2D/AnimationPlayer
@onready var sprite = $Sprite2D
var fireball_scene =preload("res://scenes/fireball.tscn")
@onready var hands = $Hands
var recoil_speed=500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 980


func _physics_process(delta):
	# Add the gravity.
	var direction = Input.get_axis("move_left", "move_right")
	if not is_on_floor():
		if(velocity.y <= MAX_FALL_SPEED):
			velocity.y += gravity * delta
		if direction and not((direction>0 and velocity.x>MAXSPEED) or(direction<0 and velocity.x<=(MAXSPEED*-1))):
				velocity.x += direction*ACCELERATION*delta

	else:
		
	# Handle jump.
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	update_animations(direction)
	move_hands()
	
func update_animations(direction):
	if(direction > 0):
			sprite.flip_h = 0;
	elif(direction < 0):
			sprite.flip_h = 1;
	if(is_on_floor()):
		if(direction):
			anim.play("move");
		else:
			anim.play("idle");
			
	else:
		if(velocity.y > 0):
			anim.play("fall")
		else:
			anim.play("jump")
		
func move_hands():
	var mPos = get_global_mouse_position();
	var normalized = (mPos-position).normalized();
	if(normalized.x > 0):
		hands.flip_v = 0;
	elif(normalized.x < 0):
		hands.flip_v = 1;
	hands.look_at(mPos);
	if(Input.is_action_just_pressed("click")):
		load_fireball(normalized);
	if(Input.is_action_just_released("click")):
		shoot_fireball(normalized);
		
func load_fireball(normalized):
	fireball=fireball_scene.instantiate()
	hands.add_child(fireball)
	fireball.position.x=9
	print(normalized)
	
func shoot_fireball(normalized):
	var fireball_pos=fireball.global_position
	var fireball_rot=fireball.global_rotation
	var scene_parent=get_parent()
	fireball.direction=normalized
	fireball.is_fired=true
	hands.remove_child(fireball)
	scene_parent.add_child(fireball)
	fireball.global_position=fireball_pos
	fireball.global_rotation=fireball_rot
	velocity+=-recoil_speed*normalized	
	
	
	
