extends Spell

var recoil_speed = 100.0
var time_loaded = 0

func _ready():
	scene = preload("res://scenes/spells/projectiles/lightning.tscn")
	ammo = 3;
	max_ammo = 3;
	print("switched to lightning")

func load_spell():
	projectile = scene.instantiate()
	projectile.type = "lightning";
	projectile.damage = 0.1;
	add_child(projectile)
	projectile.position.x = 9
	time_loaded = 0
	charging = true

func charge_spell(delta):
	projectile.is_fired = true;	
	projectile.direction = direction;
	recoil.emit(randf_range(recoil_speed, -recoil_speed));

func shoot_spell():
	charging = false
	projectile.is_fired = false	
	recoil.emit(recoil_speed);
