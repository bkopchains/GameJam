extends BaseDialogueTestScene;

func _ready():
	var balloon = load('res://dialog/balloon/balloon.tscn').instantiate();
	get_tree().current_scene.add_child(balloon);
	balloon.start(resource, title);
