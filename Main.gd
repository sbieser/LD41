extends Node

onready var grub_scene = preload("res://Enemy_Grub.tscn")

var food_count = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Timer_timeout():
	#pass # replace with function body
	#print("main::_on_Timer_timeout")
	var grub_instance = grub_scene.instance()
	grub_instance.position = $SpawnGrub_1.position
	add_child(grub_instance)


func _on_Player_button_pressed(button_type):
	#pass # replace with function body
	print("_on_Player_button_pressed")
	match button_type:
		0:
			print("this is the food button")
		1:
			print("this is the play button")
		2:
			print("this is the discipline button")


func _on_Player_hit():
	#this is for testing purposes
	food_count = food_count + 1
	$HUD.update_score(food_count)
	
