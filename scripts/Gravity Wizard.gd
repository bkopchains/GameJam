extends Enemy
 
var trigger_distance=200
var cast_frequency = 4.0
var spell_duration = 5.0
var wait_time = 0.0
var cast_time = 0.0
var time_waiting=0.0
var time_casting = 0.0
var is_waiting = false
var is_casting=false
var player_seen = false
var starting_gravity=0.0
var low_gravity = 75
@onready var animation_player = $Sprite2D/AnimationPlayer
@onready var point_light_2d = $PointLight2D
@onready var visible_on_screen_notifier_2d = $VisibleOnScreenNotifier2D

# Called when the node enters the scene tree for the first time.
func _ready():
	HP = 3.0;
	MAX_HP = 3.0;
	starting_gravity=player.gravity
	cast_time= randfn( spell_duration,1.0)
	wait_time=randfn( cast_frequency,1.0)
	point_light_2d.energy=0



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible_on_screen_notifier_2d.is_on_screen():
		time_waiting+=delta
		if time_waiting>wait_time:
			if !is_casting:
				animation_player.play("start cast")
				is_casting=true
			player.gravity=low_gravity
			point_light_2d.energy=2
			time_casting+=delta
			if time_casting>cast_time:
				time_waiting=0
				time_casting=0
				point_light_2d.energy=0
				player.gravity=starting_gravity
				is_casting=false
				animation_player.play_backwards("start cast")
				animation_player.play("idle")
				cast_time= randfn( spell_duration,1.0)
				wait_time=randfn( cast_frequency,1.0)
	else:
		time_waiting=0
		time_casting=0
		point_light_2d.energy=0
		player.gravity=starting_gravity
		animation_player.play("idle")

func _on_hitbox_area_entered(area):
	print("Hit!")
	hurt(area.damage);
	# some sort of knockback
	#global_position -= vec_to_player.normalized() * 10
	if (HP <= 0):
		die();
	



			

