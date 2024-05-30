extends Camera2D

@export var player: Player;
const SCROLL_SPEED: float = 0.5;

var player_grid_pos: Vector2 = Vector2(0,0);
var last_player_grid_pos: Vector2 = Vector2(0,0);

func _on_left_body_exited(body):
	if(body.name == player.name and player.move.x <0):
		position.x -= Global_Constants.SCREEN_SIZE.x;


func _on_right_body_exited(body):
	if(body.name == player.name and player.move.x > 0):
		position.x += Global_Constants.SCREEN_SIZE.x;


func _on_top_body_exited(body):
	if(body.name == player.name and player.move.y < 0):
		position.y -= Global_Constants.SCREEN_SIZE.y;


func _on_bottom_body_exited(body):
	if(body.name == player.name and player.move.y > 0):
		position.y += Global_Constants.SCREEN_SIZE.y;
