extends CharacterBody2D

@export var ACCELERATION = 500
@onready var anim = $Sprite2D/AnimationPlayer
@onready var sprite = $Sprite2D
@onready var hands = $Hands

const SPEED = 200.0
const MAXSPEED = 200.0
const JUMP_VELOCITY = -300.0
const MAX_FALL_SPEED = 400

# fireball vars
var fireball = null
var fireball_scene = preload ("res://scenes/fireball.tscn")
var starting_recoil_speed = 300.0
var recoil_speed = 300.0
var loading = false
var time_loaded = 0
var time_denominator = .3
var fireball_scaler = 1
var min_fireball_scaler=1
var max_fireball_scaler = 1.5
var starting_fireball_speed = 200.0
var starting_fireball_scale = null

var starting_gravity = 980
var gravity = 980
var is_alive = true
var jump_boost=-20
var fall_boost=20

func _ready():
	is_alive = true
func _physics_process(delta):
	# Add the gravity.
	var direction = Input.get_axis("move_left", "move_right")
	if not is_on_floor():
		if (velocity.y <= MAX_FALL_SPEED):
			velocity.y += gravity * delta
		if direction and not ((direction > 0 and velocity.x > MAXSPEED) or (direction < 0 and velocity.x <= (MAXSPEED * - 1))):
			velocity.x += direction * ACCELERATION * delta

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
	
	
	if (loading and fireball):
		charge_fireball(delta);
	
	move_and_slide()
	update_animations(direction)
	move_hands()
	
	if (Input.is_action_just_pressed("right_click")):
		gravity = 0
	if (Input.is_action_just_released("right_click")):
		gravity = starting_gravity
		
func update_animations(direction):
	if (direction > 0):
			sprite.flip_h = 0;
	elif (direction < 0):
			sprite.flip_h = 1;
	if (is_on_floor()):
		if (direction):
			anim.play("move");
		else:
			anim.play("idle");
			
	else:
		if (velocity.y > 0):
			anim.play("fall")
		else:
			anim.play("jump")
		
func move_hands():
	var mPos = get_global_mouse_position();
	var normalized = (mPos - position).normalized();
	if (normalized.x > 0):
		hands.flip_v = 0;
	elif (normalized.x < 0):
		hands.flip_v = 1;
	hands.look_at(mPos);
	if (Input.is_action_just_pressed("click")):
		load_fireball(normalized);
	if (fireball and Input.is_action_just_released("click")):
		shoot_fireball(normalized);
	
		
func load_fireball(normalized):
	fireball = fireball_scene.instantiate()
	hands.add_child(fireball)
	fireball.position.x = 9
	starting_fireball_speed = fireball.FIREBALL_SPEED
	starting_fireball_scale = fireball.scale
	time_loaded = 0
	loading = true

func charge_fireball(delta):
	time_loaded += delta

	if (time_loaded / time_denominator > max_fireball_scaler):
		fireball_scaler = max_fireball_scaler
	elif(time_loaded / time_denominator < min_fireball_scaler):
		fireball_scaler = min_fireball_scaler
	else:
		fireball_scaler = time_loaded / time_denominator

	fireball.scale = fireball_scaler * starting_fireball_scale
	recoil_speed = fireball_scaler * starting_recoil_speed
	fireball.FIREBALL_SPEED = fireball_scaler * starting_fireball_speed

func shoot_fireball(normalized):
	var fireball_pos = fireball.global_position
	var fireball_rot = fireball.global_rotation
	var scene_parent = get_parent()
  
	loading = false
	fireball.direction = normalized
	fireball.is_fired = true
	hands.remove_child(fireball)
	scene_parent.add_child(fireball)
	fireball.global_position = fireball_pos
	fireball.global_rotation = fireball_rot
	if(velocity.y<0):
		velocity = - recoil_speed * normalized+Vector2(0,jump_boost)
	elif(velocity.y>MAX_FALL_SPEED):
				velocity = - recoil_speed * normalized+Vector2(0,fall_boost)
	else:
		velocity = - recoil_speed * normalized

	if(velocity.y<0):
		velocity = - recoil_speed * normalized+Vector2(0,jump_boost)
	elif(velocity.y>MAX_FALL_SPEED):
				velocity = - recoil_speed * normalized+Vector2(0,fall_boost)
	else:
		velocity = - recoil_speed * normalized
