extends CharacterBody2D
var player = null
var speed=80
var react_distance=200

# Called when the node enters the scene tree for the first time.

func _ready():
	player=get_node("../Wizard")
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var vec_to_player=player.global_position-global_position
	var distance_to_player = vec_to_player.length()
	if(distance_to_player<react_distance):
		global_position+=speed*vec_to_player.normalized()*delta

	
