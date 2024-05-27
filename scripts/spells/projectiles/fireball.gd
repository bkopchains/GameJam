extends Projectile
@export var FIREBALL_SPEED = 220
@export var direction: Vector2 = Vector2()
@onready var animation_player = $Sprite2D/AnimationPlayer
@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D

@onready var collision_timer = $CollisionTimer
@onready var splash = $Splash
@onready var embers = $Embers
@onready var light = $PointLight2D



# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("loaded")
	scale = scale*1.5;
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(is_fired and !is_dying):
		animation_player.play("fired")
		
		if(Global_Constants.SPELL_GRAVITY_ENABLED):
			var gravity = 0.02 * (1/scale.x);
			direction.y += gravity; # "so-called gravity"
		
		rotation = position.angle_to_point(position + direction)
		#rotation_degrees += 0.5 if direction.x > 0 else -0.5 
		global_translate(direction*FIREBALL_SPEED*delta)
	
	if(is_dying and light.energy > 0):
		light.energy -= 0.2
		light.scale *= 0.9

	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	pass # Replace with function body.


func _on_area_entered(area):
	on_collision();
func _on_body_entered(body):
	on_collision();
	
func _on_collision_timer_timeout():
		queue_free();

func on_collision():
	if(!is_dying and is_fired):
		set_deferred("monitorable", false)
		is_fired = false;
		is_dying = true;
		sprite_2d.visible = false;
		embers.emitting = false;
		splash.restart();
		collision_timer.start();

