extends Spell

const starting_recoil_speed = 300.0
var recoil_speed = 300.0
var time_loaded = 0
var time_denominator = .3
var fireball_scaler = 1
var min_fireball_scaler = 1
var max_fireball_scaler = 1.5
var starting_fireball_speed = 200.0
var starting_fireball_scale = null

func _ready():
	scene = preload("res://scenes/spells/projectiles/fireball.tscn")
	ammo = 3;
	max_ammo = 3;
	print("switched to fireball")

func load_spell():
	projectile = scene.instantiate()
	projectile.type = "fireball";
	projectile.damage = 1;
	add_child(projectile)
	projectile.position.x = 9
	starting_fireball_speed = projectile.FIREBALL_SPEED
	starting_fireball_scale = projectile.scale
	time_loaded = 0
	charging = true

func charge_spell(delta):
	
	time_loaded += delta

	if (time_loaded / time_denominator > max_fireball_scaler):
		fireball_scaler = max_fireball_scaler
	elif(time_loaded / time_denominator < min_fireball_scaler):
		fireball_scaler = min_fireball_scaler
	else:
		fireball_scaler = time_loaded / time_denominator

	projectile.scale = fireball_scaler * starting_fireball_scale
	recoil_speed = fireball_scaler * starting_recoil_speed
	projectile.FIREBALL_SPEED = fireball_scaler * starting_fireball_speed

func shoot_spell():
	var fireball_pos = projectile.global_position
	var fireball_rot = projectile.global_rotation
  
	spend_ammo();
	
	charging = false
	projectile.direction = Vector2(direction)
	projectile.is_fired = true
	remove_child(projectile)
	get_tree().root.add_child(projectile)
	projectile.global_position = fireball_pos
	projectile.global_rotation = fireball_rot
	
	recoil.emit(recoil_speed);
