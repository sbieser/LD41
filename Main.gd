extends Node

onready var grub_scene = preload("res://Enemy_Grub.tscn")
onready var fly_scene = preload("res://Enemy_Fly.tscn")

export (int) var food_count = 0				# The currency in which to feed the tama

var all_grubs = []
var all_flys = []
var spawn_list

signal restart
signal main_menu
signal game_over

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	spawn_list = [$Fly_spawn1, $Fly_spawn2, $SpawnGrub_1]
	self.connect( "game_over", self, "handle_game_over")
	self.connect( "restart", self, "handle_restart_game" )
	self.connect( "main_menu", self, "handle_main_menu" )
	#self.connect( "enemy_died", self, "_on_Player_hit" )

func _on_Timer_timeout():
	#pass # replace with function body
	#print("main::_on_Timer_timeout")
	if all_grubs.size() < 5:
		var grub_instance = grub_scene.instance()
		grub_instance.connect("enemy_died", self, "_on_enemy_dies")
		var i = spawn_list[randi()%3]
		grub_instance.position = i.position
		add_child(grub_instance)
		all_grubs.push_back(grub_instance)


func _on_Player_button_pressed(button_type):
	#pass # replace with function body
	#print("_on_Player_button_pressed")
	match button_type:
		0:
			#print("this is the food button")
			if (food_count > 0):
				food_count = food_count - 1
				$HUD.update_score(food_count)
				$Tama.food(1)
			#food_count = food_count - 1
			#$HUD.update_score(food_count)
		1:
			#print("this is the play button")
			pass
		2:
			#print("this is the discipline button")
			pass
	
func _on_SpawnTimer_timeout():
	#
	if all_flys.size() < 5:
		randomize()
		var fly_instance = fly_scene.instance()
		fly_instance.connect("enemy_died", self, "_on_enemy_dies")
		var i = spawn_list[randi()%3]
		fly_instance.position = i.position
		add_child(fly_instance)
		all_flys.push_back(fly_instance)

func handle_restart_game():
	print("handling retry")
	$HUD.emit_signal("restart")
	pass
	
func handle_main_menu():
	print("handling main menu")
	$HUD.emit_signal("main_menu")
	pass
	
func handle_game_over():
	$HUD.emit_signal("game_over")

		
func _on_enemy_dies(enemy):
	$HitSound.play()
	food_count = food_count + 3
	$HUD.update_score(food_count)
	if "Enemy_Fly" in enemy.get_name():
		all_flys.erase(enemy)
	elif "Enemy_Grub" in enemy.get_name():
		all_grubs.erase(enemy)
		

func _on_Tama_change_animation(animation):
	$TamaAnimatedSprite.play(animation)

func _on_Tama_tama_update(happiness, hungriness):
	$HUD.update_happy_hunger(happiness, hungriness)

func _on_Tama_tama_died():
	print("_on_Tama_tama_died")
