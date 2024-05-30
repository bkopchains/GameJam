class_name Constants;
extends Node

const SCREEN_SIZE = Vector2(320, 180);

const SPELLS: Dictionary = {
	"fireball" : preload("res://scenes/spells/fireball.tscn"),
	"fireball+" : preload("res://scenes/spells/fireball+.tscn")
}

const STARTING_SPELLS: Dictionary = {
	"fireball" : preload("res://scenes/spells/fireball.tscn")
}

const SPELL_GRAVITY_ENABLED = false;
