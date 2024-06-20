class_name Constants;
extends Node

const SCREEN_SIZE = Vector2(480, 270);

const SPELLS: Dictionary = {
	"NOTHING" : null,
	"fireball" : preload("res://scenes/spells/fireball.tscn"),
	"fireball+" : preload("res://scenes/spells/fireball+.tscn"),
	"lightning" : preload("res://scenes/spells/lightning.tscn")
}

## to be updated while getting new spells
## used by dialog etc
var PLAYER_SPELLS: Dictionary = {}

const SPELL_GRAVITY_ENABLED = false;

## if true, uses mouse aiming
var mouse_aiming = true;
