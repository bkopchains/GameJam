class_name Spellbook;
extends Area2D;

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var spell_name: String;
@export var spell_scene: PackedScene;
@export var player : Player 

var collected = false;

func player_book_pickup(body: Node2D):
	if(body == player and !collected):
		collected = true;
		animation_player.play("collect");
		player.add_spell(spell_name);
		await get_tree().create_timer(2).timeout;
		queue_free();
