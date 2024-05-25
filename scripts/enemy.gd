class_name Enemy
extends Area2D

@export var Player : CharacterBody2D 
@export var MAX_HP : float;
@export var HP : float;
@export var XP : int;
@onready var sprite_2d: Sprite2D = $Sprite2D
const ENEMY_DEATH = preload("res://scenes/fx/enemy_death.tscn")

signal reward(XP);

func hurt(damage: float):
	HP -= damage;
	if(sprite_2d):
		var newVal = 1-HP/MAX_HP;
		sprite_2d.material.set_shader_parameter("flash_modifier", newVal)

func die():
	var pos = Vector2(global_position);
	var fx: CPUParticles2D = ENEMY_DEATH.instantiate();
	get_tree().root.add_child(fx);
	fx.global_position = pos;
	fx.splat();
	reward.emit(XP);
	queue_free();

func kill_player(body: Node2D):
	if(body.name == Player.name):
		body.is_alive=false;
		body.get_node("CollisionShape2D").queue_free();
		get_tree().reload_current_scene();
