extends Sprite2D

@export var dialog_resource: DialogueResource;
@export var dialog_start: String = "start";
@onready var actionable = $Actionable
@onready var ap = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	actionable.dialog_resource = dialog_resource;
	actionable.dialog_start = dialog_start;
	actionable.actioned.connect(sign_read);
	
func sign_read():
	ap.play("actioned");
