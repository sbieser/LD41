extends Node

signal tama_died
signal restart
signal tama_update(happiness, hungriness)
signal change_animation(animation)

export (int) var tama_happiness = 0 		# max 30?
export (int) var tama_hungriness = 0 		# max 30?
export (int) var tama_rating = 0 			# max 30?
export (int) var death_threshold = -5		# if tama_happiness and tama_hungriness reach this level, should
											#	equate death
export (int) var max_meter_threshold = 40	# if fullness of happy or food reach 40, should not go over this amount
export (float) var reduce_rate = 5
export (float) var change_animation = 10
export (int) var food_reduce_rate = 1
export (int) var happy_reduce_rate = 1

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	emit_signal("change_animation", "egg")
	emit_signal("tama_update", tama_happiness, tama_hungriness)
	$ReduceTimer.wait_time = reduce_rate
	$AnimationTimer.wait_time = change_animation
	$AnimationTimer.start()
	
	connect("restart", self, "_on_restart_game")

func food(food):
	tama_hungriness = tama_hungriness + food
	if tama_hungriness > max_meter_threshold:
		tama_hungriness = max_meter_threshold
	emit_signal("tama_update", tama_happiness, tama_hungriness)
	
func happy(happy):
	tama_happiness = tama_happiness + happy
	if tama_happiness > max_meter_threshold:
		tama_happiness = max_meter_threshold
	emit_signal("tama_update", tama_happiness, tama_hungriness)

func _on_ReduceTimer_timeout():
	tama_happiness = tama_happiness - happy_reduce_rate
	if tama_happiness < death_threshold:
		tama_happiness = death_threshold
	tama_hungriness = tama_hungriness - food_reduce_rate
	if tama_hungriness < death_threshold:
		tama_hungriness = death_threshold
		
	if tama_happiness == death_threshold or tama_hungriness == death_threshold:
		$ReduceTimer.stop()
		emit_signal("tama_died")
	else:
		emit_signal("tama_update", tama_happiness, tama_hungriness)
		
func _on_AnimationTimer_timeout():
	emit_signal("change_animation", "baby_idle")
	$ReduceTimer.start()
	
func _on_restart_game():
	tama_happiness = 0
	tama_hungriness = 0
	emit_signal("change_animation", "egg")
	emit_signal("tama_update", tama_happiness, tama_hungriness)
	$ReduceTimer.wait_time = reduce_rate
	$AnimationTimer.wait_time = change_animation
	$AnimationTimer.start()