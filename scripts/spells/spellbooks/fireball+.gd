extends Spellbook;

func _ready():
	spell_name = "fireball+";
	spell_scene = load("res://scenes/spells/fireball+.tscn");

func _on_body_entered(body):
	player_book_pickup(body);
