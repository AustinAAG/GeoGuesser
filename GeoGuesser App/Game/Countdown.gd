extends Container

onready var sec = $sec
onready var timer = $Timer

export  (int) var time = 0
var dsec = 0
var seconds = 0
signal timer_ended

func _ready():
	seconds = time


func _physics_process(delta):
	if seconds >= 0 and dsec <= 0:
		seconds -= 1
		dsec = 10
	
	if seconds == -1:
		emit_signal("timer_ended")
		seconds = time
		timer.stop()
	
	if seconds >= 10:
		sec.set_text(str(seconds))
	else:
		sec.set_text("0"+str(seconds))


func _on_Timer_timeout():
	dsec -= 1
