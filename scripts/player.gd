extends CharacterBody2D

@export var ACCELERATION = 500
@onready var anim = $Sprite2D/AnimationPlayer
@onready var sprite = $Sprite2D
@onready var bubble = $Bubble
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

#bubble vars
var is_bubbled = false;

# movement vars
var move: Vector2 = Vector2()
var starting_gravity = 980
var gravity = 980
var is_alive = true
var jump_boost=-20
var fall_boost=20
var on_floor = false;
var on_wall = false;
var collision_info: KinematicCollision2D = null;

func _ready():
	is_alive = true
func _physics_process(delta):
	print(move.x);
	# Add the gravity.
	var direction = Input.get_axis("move_left", "move_right")
	if not on_floor:
		if (move.y <= MAX_FALL_SPEED or is_bubbled):
			move.y += gravity * delta
		if direction and (
			not ((direction > 0 and move.x > MAXSPEED) or (direction < 0 and move.x <= (MAXSPEED * - 1))) 
			or is_bubbled
		):
			move.x += direction * ACCELERATION * delta
		
		if(on_wall and Input.is_action_just_pressed("jump") and collision_info):
			on_wall = false;
			move.y = JUMP_VELOCITY;
			move.x = collision_info.get_normal().x * SPEED;
	else:
		move.y = 1;
		# Handle jump.
		if Input.is_action_just_pressed("jump"):
			move.y = JUMP_VELOCITY
			on_floor = false;

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		if direction:
			move.x = direction * SPEED
		else:
			move.x = move_toward(velocity.x, 0, SPEED)
	
	
	if (loading and fireball):
		charge_fireball(delta);
	
	collision_info = move_and_collide(move * delta, false, 0.01)
	if (Input.is_action_pressed("right_click")):
		is_bubbled = true;
		bubble.visible = true;
		if collision_info:
			move = move.bounce(collision_info.get_normal())
	else:
		is_bubbled = false;
		bubble.visible = false;
		
		if (collision_info):
			var collision_angle = roundf(rad_to_deg(collision_info.get_angle()));
			if(collision_angle == 0):
				on_floor = true;
				on_wall = false;
			elif(collision_angle == 180):
				move.y = 0;
			elif(collision_angle == 90):
				on_wall = true;
			
			move = move.slide(collision_info.get_normal())
		else:
			if(on_wall):
				move.y = gravity * delta;	
			on_wall = false;
			on_floor = false;
		
	update_animations(direction)
	move_hands()
	
	#if (Input.is_action_just_pressed("right_click")):
		#gravity = 0
	#if (Input.is_action_just_released("right_click")):
		#gravity = starting_gravity

func update_animations(direction):
	if (direction > 0):
			sprite.flip_h = 0;
	elif (direction < 0):
			sprite.flip_h = 1;
	if (on_floor):
		if (direction):
			anim.play("move");
		else:
			anim.play("idle");
	elif (on_wall):
		anim.play("wall_slide");
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
		load_fireball();
	if (fireball and Input.is_action_just_released("click")):
		shoot_fireball(normalized);

func load_fireball():
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
	on_floor = false;
	if(velocity.y<0):
		move =- recoil_speed * normalized+Vector2(0,jump_boost)
	elif(velocity.y>MAX_FALL_SPEED):
				move =- recoil_speed * normalized+Vector2(0,fall_boost)
	else:
		move =- recoil_speed * normalized
