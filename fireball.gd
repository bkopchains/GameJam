extends Area2D
@export var FIREBALL_SPEED =220
@export var direction = Vector2()
@export var is_fired= false
@onready var animation_player = $Sprite2D/AnimationPlayer
@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D



# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("loaded")
	scale = scale*1.5;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(is_fired):
		animation_player.play("fired")
		global_translate(direction*FIREBALL_SPEED*delta)

	pass


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	pass # Replace with function body.
