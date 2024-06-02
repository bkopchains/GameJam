class_name Constants;
extends Node

const SCREEN_SIZE = Vector2(480, 270);

const SPELLS: Dictionary = {
	"NOTHING" : null,
	"fireball" : preload("res://scenes/spells/fireball.tscn"),
	"fireball+" : preload("res://scenes/spells/fireball+.tscn")
}

const STARTING_SPELLS: Dictionary = {}

const SPELL_GRAVITY_ENABLED = true;

## if true, uses mouse aiming
var mouse_aiming = true;
