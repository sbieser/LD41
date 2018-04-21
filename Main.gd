extends Node

onready var grub_scene = preload("res://Enemy_Grub.tscn")

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

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
