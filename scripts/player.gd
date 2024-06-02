class_name Player
extends CharacterBody2D

@export var ACCELERATION = 500
@onready var anim = $Sprite2D/AnimationPlayer
@onready var sprite = $Sprite2D
@onready var bubble = $Bubble
@onready var hands: Sprite2D = $Hands
@onready var fireball_timer = $Fireball_Timer

@onready var debug1: Label = $debug1
@onready var debug2: Label = $debug2

const SPEED = 200.0
const MAXSPEED = 200.0
const JUMP_VELOCITY = -300.0
const MAX_FALL_SPEED = 400

#bubble vars
var is_bubbled = false;

# movement vars
var move: Vector2 = Vector2()
var starting_gravity = 980
var gravity = 980
var is_alive = true
var jump_boost = -20
var fall_boost = 20
var on_floor = false;
var on_wall = false;
var collision_info: KinematicCollision2D = null;

#spell vars
var current_spell_idx: int = 0;
var spell: Spell;
var aim_direction: Vector2 = Vector2();
var spells: Dictionary;

# signals
signal ammo_changed(value);
signal ammo_max_changed(value);
signal reload_started(time);

func _ready():
	spells = Global_Constants.STARTING_SPELLS.duplicate(true);
	is_alive = true
	switch_spell(current_spell_idx);
	
func _physics_process(delta):
	var pos = position
	if Input.is_action_just_pressed("ui_cancel"):
		DialogueManager.show_dialogue_balloon(load("res://dialog/intro.dialogue"), "intro");
		
	# Add the gravity.
	var direction = Input.get_axis("move_left", "move_right")
	if not on_floor:
		if (move.y <= MAX_FALL_SPEED or is_bubbled):
			move.y += gravity * delta
		if direction != 0 and (
			not ((direction > 0 and move.x >= MAXSPEED) or (direction < 0 and move.x <= (MAXSPEED * -1))) 
			or is_bubbled
		):
			var mvmt = direction * ACCELERATION * delta;
			move.x += mvmt;
		#elif(direction == 0):
			#move.x = move_toward(velocity.x, 0, 0.01);
		
		if(on_wall):
			# wall jump
			if(Input.is_action_just_pressed("jump") and collision_info):
				on_wall = false;
				move.y = JUMP_VELOCITY;
				move.x = collision_info.get_normal().x * SPEED;
			# prevent zooming down when moving after wall slide
			elif(move.y >= 0):
				move.y = gravity * delta * 5;
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

	
	if (spell and spell.charging and is_instance_valid(spell.projectile)):
		spell.charge_spell(delta);
	velocity = move;
	move_and_slide()
	collision_info = get_last_slide_collision()
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
			on_wall = false;
			on_floor = false;
		
	if(Input.is_action_just_pressed("next_spell")):
		switch_spell((current_spell_idx+1) % spells.size());
	if(Input.is_action_just_pressed("prev_spell")):
		switch_spell((current_spell_idx-1) % spells.size());
	
	update_animations(direction);
	move_hands();
	
	if(spell and spell.ammo < spell.max_ammo and fireball_timer.time_left == 0):
		var timer_length = 1.5 # + (float(ammo)/float(max_ammo))
		reload_started.emit(timer_length);
		fireball_timer.start(timer_length);
	
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

func add_spell(spell_name: String):
	if(Global_Constants.SPELLS.has(spell_name)):
		spells[spell_name] = Global_Constants.SPELLS.get(spell_name);
		switch_spell_by_name(spell_name);

func switch_spell(idx: int):
	if(!spells.is_empty()):
		# get starting spell
		current_spell_idx = idx;
		var spell_key = spells.keys()[idx];
		switch_spell_by_name(spell_key);

func switch_spell_by_name(spell_name: String):
	if(!spells.is_empty()):
		var new_spell: Spell = spells[spell_name].instantiate();
		new_spell.initialize(self);
		
		# clear spell to be safe
		if(spell):
			spell.queue_free();
			
		# equip the spell
		hands.add_child(new_spell);
		new_spell.ammo_changed.connect(update_ammo);
		new_spell.recoil.connect(recoil);
		if(spell):
			new_spell.ammo = spell.ammo if spell.ammo <= new_spell.max_ammo else new_spell.max_ammo;
		emit_signal("ammo_max_changed", new_spell.max_ammo);
		emit_signal("ammo_changed", new_spell.ammo);
		# save the reference
		spell = new_spell;

func move_hands():
	if(Global_Constants.mouse_aiming):
		var mPos = get_global_mouse_position();
		var mouse_direction = (mPos - position).normalized();
		aim_direction = mouse_direction;
	else:
		var move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		aim_direction = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
		aim_direction = move_direction if aim_direction.is_zero_approx() else aim_direction;
	if (aim_direction.x > 0):
		hands.flip_v = 0;
	elif (aim_direction.x < 0):
		hands.flip_v = 1;
	hands.look_at(aim_direction*10 + position);
	if(spell):
		spell.direction = aim_direction;
		if(spell.ammo > 0):
			if (Input.is_action_just_pressed("click") and Input.get_action_raw_strength("click") > 0):
				spell.load_spell();
			if (is_instance_valid(spell.projectile) and !spell.projectile.is_dying and spell.charging and Input.get_action_raw_strength("click") == 0):
				spell.shoot_spell();
			print(aim_direction);

func recoil(recoil_speed):
	on_floor = false;
	if(velocity.y<0):
		move =- recoil_speed * aim_direction+Vector2(0,jump_boost)
	elif(velocity.y>MAX_FALL_SPEED):
				move =- recoil_speed * aim_direction+Vector2(0,fall_boost)
	else:
		move =- recoil_speed * aim_direction

# TODO: move into spell
func _on_fireball_timer_timeout():
	spell.add_ammo();

func update_ammo(value):
	ammo_changed.emit(value);
