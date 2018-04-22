extends Node

signal tama_died
signal tama_update(happiness, hungriness)
signal change_animation(animation)

export (int) var animation_change = 10
export (int) var animation_current = 0
export (int) var tama_happiness = 0 		# max 30?
export (int) var tama_hungriness = 0 		# max 30?
export (int) var tama_rating = 0 			# max 30?
export (int) var death_threshold = -5		# if tama_happiness and tama_hungriness reach this level, should
											#	equate death
											


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	emit_signal("change_animation", "egg")

func _on_ReduceTimer_timeout():
	print("_on_ReduceTimer_timeout")
	tama_happiness = tama_happiness - 1
	if tama_happiness < death_threshold:
		tama_happiness = death_threshold
	tama_hungriness = tama_hungriness - 1
	if tama_hungriness < death_threshold:
		tama_hungriness = death_threshold
		
	if tama_happiness == death_threshold and tama_hungriness == death_threshold:
		$ReduceTimer.stop()
		emit_signal("tama_died")
	else:
		emit_signal("tama_update", tama_happiness, tama_hungriness)
		

func _on_AnimationTimer_timeout():
	print("_on_AnimationTimer_timeout")
	animation_current = animation_current + 1
	if animation_current >= animation_change:
		$AnimationTimer.stop()
		emit_signal("change_animation", "baby_idle")
