class_name Actionable
extends Area2D

@export var dialog_resource: DialogueResource;
@export var dialog_start: String = "start";

var balloon = null;

signal actioned;

func action() -> void:
	if(is_instance_valid(balloon)):
		balloon.queue_free();
		balloon = null;
	
	actioned.emit();
	Game.start_dialog(dialog_resource, dialog_start);
