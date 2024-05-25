extends Enemy

var speed=80
var react_distance=200
var vec_to_player

func _ready():
	HP = 3.0;
	MAX_HP = 3.0;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	vec_to_player = Player.global_position - global_position
	var distance_to_player = vec_to_player.length()
	if(distance_to_player < react_distance):
		global_position += speed * vec_to_player.normalized() * delta

func _on_hitbox_area_entered(area):
	print(area.type)
	hurt(area.damage);
	# some sort of knockback
	#global_position -= vec_to_player.normalized() * 10
	if (HP <= 0):
		die();


func _on_hitbox_body_entered(body): 
	kill_player(body);
