extends Node2D

var paused = false;
var dialog: CanvasLayer = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pause_menu();
		# TODO: pause/unpause dialog
		if is_instance_valid(dialog) and dialog.is_queued_for_deletion() or (dialog != null and !is_instance_valid(dialog)):
			end_dialog();

func start_dialog(dialog_resource: DialogueResource, title: String = "", extra_game_states: Array = []):
	dialog = DialogueManager.show_dialogue_balloon(dialog_resource, title, extra_game_states);
	paused = true;
	
func end_dialog():
	paused = false;


func pause_menu():
	#if(paused):
		#Engine.time_scale = 1;
	#else:
		#Engine.time_scale = 0;
	paused = !paused;
