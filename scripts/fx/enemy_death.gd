extends CPUParticles2D

@onready var timer = $Timer

func splat():
	restart();
	timer.start(3);


func _on_timer_timeout():
	queue_free();
