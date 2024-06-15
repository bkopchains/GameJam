class_name Projectile
extends Area2D

var parent: Spell;
var type: String;
var damage: float;
var is_fired: bool = false;
var is_dying: bool = false;
@export var direction: Vector2 = Vector2();

func _ready():
	parent = get_parent();
