extends Area2D

func _on_body_entered(body): 
	body.is_alive=false
	body.get_node("CollisionShape2D").queue_free();
	get_tree().reload_current_scene();
