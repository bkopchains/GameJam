class_name Spell;
extends Node2D;

var scene : PackedScene;
var projectile : Projectile;
var player: CharacterBody2D;
var ammo: int;
var max_ammo: int;
var direction: Vector2;
var charging = false;

signal ammo_changed(value);
signal recoil(recoil_speed);
	
#func _physics_process(delta):
	#if(player):
		#var mPos = get_global_mouse_position();
		#direction = (mPos - player.position).normalized();
	
# do we need this?
func initialize(_player: CharacterBody2D):
	player = _player;

# "interfaces"
func load_spell():
	pass;
func charge_spell(delta):
	pass;
func shoot_spell():
	pass;

func add_ammo():
	ammo += 1;
	ammo_changed.emit(ammo);
func spend_ammo():
	ammo -= 1;
	ammo_changed.emit(ammo);
