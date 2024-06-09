extends RigidBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var arm = $Arm
@onready var body = $Body

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var speed = 1000;

func _physics_process(delta):
	var mousePos = get_global_mouse_position();
	arm.look_at(mousePos);
	if(get_global_mouse_position().x > body.global_position.x):
		body.flip_h = 0; 
	else:
		body.flip_h = 1;
	
	if(Input.is_action_just_pressed("click")):
		print('test');
		var vector = mousePos - global_position;
		var normalized = vector.normalized();
		apply_central_force(vector * speed)
