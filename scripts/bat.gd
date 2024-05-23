extends Area2D
var speed=80
var react_distance=200
@onready var player = $"../../../Wizard"

var vec_to_player
var HP = 3;
var _delta;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_delta = delta;
	vec_to_player = player.global_position - global_position
	var distance_to_player = vec_to_player.length()
	if(distance_to_player < react_distance):
		global_position += speed * vec_to_player.normalized() * delta

func _on_area_entered(area):
	pass;

func _on_hitbox_area_entered(area):
	HP -=1;
	# some sort of knockback
	global_position -= speed * vec_to_player.normalized() * _delta * 10 
	if (HP == 0):
		queue_free();


func _on_hitbox_body_entered(body): 
	body.is_alive=false
	body.get_node("CollisionShape2D").queue_free();
	get_tree().reload_current_scene();
