extends Node

onready var grub_scene = preload("res://Enemy_Grub.tscn")
onready var fly_scene = preload("res://Enemy_Fly.tscn")

export (int) var tama_happiness = 0 		# should be out of 100
export (int) var tama_hungriness = 0 		# should be out of 100
export (int) var tama_health = 100 			# should be out of 100
export (int) var food_count = 0				# The currency in which to feed the tama

var all_grubs = []
var all_flys = []
var spawn_list

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	spawn_list = [$Fly_spawn1, $Fly_spawn2, $SpawnGrub_1]
	pass

func _on_Timer_timeout():
	#pass # replace with function body
	#print("main::_on_Timer_timeout")
	if all_grubs.size() < 5:
		var grub_instance = grub_scene.instance()
		var i = spawn_list[randi()%3]
		grub_instance.position = i.position
		add_child(grub_instance)
		all_grubs.push_back(grub_instance)


func _on_Player_button_pressed(button_type):
	#pass # replace with function body
	print("_on_Player_button_pressed")
	match button_type:
		0:
			#print("this is the food button")
			food_count = food_count - 1
			$HUD.update_score(food_count)
		1:
			print("this is the play button")
		2:
			print("this is the discipline button")


func _on_Player_hit():
	#this is for testing purposes
	food_count = food_count + 1
	$HUD.update_score(food_count)
	


func _on_SpawnTimer_timeout():
	if all_flys.size() < 5:
		randomize()
		var fly_instance = fly_scene.instance()
		var i = spawn_list[randi()%3]
			
		fly_instance.position = i.position
		add_child(fly_instance)
		all_flys.push_back(fly_instance)
