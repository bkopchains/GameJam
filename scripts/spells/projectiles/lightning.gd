extends Projectile
@onready var collision_shape_2d = $CollisionShape2D;
@onready var collision_timer = $CollisionTimer;

@onready var line: Line2D = $Line2D;
@onready var line2: Line2D = $Line2D2
@onready var line3: Line2D = $Line2D3

@onready var timer: Timer = $Timer
@onready var sparks: CPUParticles2D = $Sparks

@onready var light_start = $Light_mid/Light_start
@onready var light: PointLight2D = $Light_mid
@onready var light_start_2 = $Light_mid/Light_start2

#@onready var light_end = $Light_mid/Light_end

@onready var raycast = $RayCast2D

# idea from https://github.com/Geminimax/Godot-2d-Lightning/blob/master/Scenes/Lightning.gd
var goal : Vector2 = Vector2(100,100)
var min_segment_size : float = 2
var max_segment_size : float = 10
var points : Array = []

@export var angle_var : float = 45

# Called when the node enters the scene tree for the first time.
func _ready():
	sparks.emitting = false;
	parent = get_parent();
	goal = direction - global_position;
	timer.start(randf_range(0.1,0.5))


#func _on_timer_timeout():
	#if(points.size() > 0):
		#points.pop_front()
		#line.points = points	
			#
		##Small variation for more organic look:
		#timer.start(0.002 + randf_range(-0.001,0.001))
	#elif(is_fired):
		#update_points()
		#line.points = points	
		#timer.start(0.1 + randf_range(-0.02,0.1))
func _physics_process(delta):
	
	if(is_fired):
		sparks.emitting = true;
		update_points(line, 1);
		update_points(line2, 2);
		update_points(line3, 0.5);
		
		var energy = randf_range(0.75,1.25)
		light.energy = energy;
		light.texture.width = goal.x+9;
		light.offset.x = goal.x/2;
		#light_end.position.x = goal.x;
	else:
		if(points.size() == 0):
			queue_free();
		light.energy = 0;
		#light_end.energy = 0;
		light_start.energy = 0;
		light_start_2.energy = 0;
		light.texture.width = goal.x;
		
		sparks.emitting = false;
		points = line.points;
		points.pop_back();
		points.pop_back();
		line.points = points;
		
		points = line2.points;
		points.pop_back();
		points.pop_back();
		line2.points = points;
		
		points = line3.points;
		points.pop_back();
		points.pop_back();
		line3.points = points;

# add jitter/etc to lightning
func update_points(to_update: Line2D, scale: float):
	
	var draw_to = get_global_mouse_position();
	if(raycast.is_colliding()):
		draw_to = raycast.get_collision_point();
	
	goal = Vector2(global_position.distance_to(draw_to),0);
	
	var curr_line_len = 0
	points = [Vector2()]
	var start_point = Vector2()
	min_segment_size = max(Vector2().distance_to(goal)/40,1) * scale
	max_segment_size = min(Vector2().distance_to(goal)/20,10) * scale
	while(curr_line_len < Vector2().distance_to(goal)):
		var move_vector = start_point.direction_to(goal) * randf_range(min_segment_size,max_segment_size)
		var new_point = start_point + move_vector
		var new_point_rotated = start_point + move_vector.rotated(deg_to_rad(randf_range(-angle_var,angle_var)))
		points.append(new_point_rotated)
		start_point = new_point
		curr_line_len = start_point.length()
		
	points.append(goal)
	to_update.points = points
	print(direction)

func _on_visible_on_screen_notifier_2d_screen_exited():
	#queue_free()
	pass # Replace with function body.


func _on_area_entered(area):
	on_collision();
func _on_body_entered(body):
	on_collision();


func on_collision():
	pass;
