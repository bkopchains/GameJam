class_name Enemy
extends Area2D

@export var Player : CharacterBody2D 
@export var HP : int;

func hurt():
	HP -= 1;

func die():
	queue_free();

func kill_player(body: Node2D):
	if(body.name == Player.name):
		body.is_alive=false;
		body.get_node("CollisionShape2D").queue_free();
		get_tree().reload_current_scene();
