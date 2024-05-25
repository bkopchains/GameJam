extends CanvasLayer

var progress = 0.0;
var progress_width = 0
var sprite_width = 6;
var reload_time = 2.0;
var ammo = 3;
var max_ammo = 3;
@export var player : CharacterBody2D;
@onready var ammo_ui_empty = $AmmoUI_Empty
@onready var ammo_ui_full = $AmmoUI_Full
@onready var ammo_reload_timer = $AmmoReload_Timer
@onready var ammo_reload_progress = $AmmoReload_Progress
@onready var ammo_reload_back = $AmmoReload_Back


func _ready():
	if(player != null):
		ammo = player.spell.ammo;
		max_ammo = player.spell.max_ammo
		player.ammo_changed.connect(change_texture);
		player.ammo_max_changed.connect(change_max);
		player.reload_started.connect(reload);
		ammo_ui_empty.size.x = max_ammo * sprite_width;
		ammo_ui_full.size.x = ammo * sprite_width
	progress_width = max_ammo * sprite_width
	ammo_reload_back.size.x = progress_width;

func _physics_process(delta):
	progress = ((reload_time - ammo_reload_timer.time_left)/reload_time) * progress_width;
	ammo_reload_progress.size.x = round(progress) if ammo < max_ammo else 0;

func reload(time):
	reload_time = time;
	ammo_reload_timer.start(time);

func change_texture(value):
	ammo = value;
	if(ammo >= 0 and ammo <= max_ammo):
		ammo_ui_full.size.x = ammo * sprite_width;

func change_max(value):
	max_ammo = value;
	ammo_ui_empty.size.x = max_ammo * sprite_width;
	ammo_ui_full.size.x = ammo * sprite_width;
	
	progress_width = max_ammo * sprite_width
	ammo_reload_back.size.x = progress_width;
	ammo_reload_progress.size.x = round(progress) if ammo < max_ammo else 0;
