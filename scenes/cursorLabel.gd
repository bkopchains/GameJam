extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = get_global_mouse_position();
	text = "("+var_to_str(ceil(position.x))+","+var_to_str(ceil(position.y))+")";
	position.y += 10
	pass
