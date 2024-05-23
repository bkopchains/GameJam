extends Enemy

@onready var ap = $Sprite2D/AnimationPlayer
@onready var sprite = $Sprite2D
@onready var timer = $HesitateTimer

@onready var rcR = $RayCast2D_R
@onready var rcRD = $RayCast2D_R_D
@onready var rcL = $RayCast2D_L
@onready var rcLD = $RayCast2D_L_D
@onready var rcRU = $RayCast2D_R_U
@onready var rcLU = $RayCast2D_L_U

var rcVerticalR;
var rcVerticalL;

@export var on_ceiling : bool = false;

var dir = 1;
var speed = 20;
var react_distance = 200;
var paused = false;

func _ready():
	dir = -1 if on_ceiling else 1;
	rcVerticalR = rcRU if on_ceiling else rcRD;
	rcVerticalL = rcLU if on_ceiling else rcLD;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
		
	if((((rcR.is_colliding() or !rcRD.is_colliding()) and dir == (-1 if on_ceiling else 1)) or 
		((rcL.is_colliding() or !rcLD.is_colliding()) and dir == (1 if on_ceiling else -1)))
		and not paused
	):
		paused = true;
		ap.play("idle");
		timer.start();
		
	if not paused:
		global_position.x += speed * delta * dir;

func _on_hitbox_area_entered(area):
	hurt();
	if (HP <= 0):
		die();

func _on_hitbox_body_entered(body): 
	kill_player(body);


func _on_hesitate_timer_timeout():
		sprite.flip_h = !sprite.flip_h;
		dir *= -1;
		paused = false;
		ap.play("walk");
