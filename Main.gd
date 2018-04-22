extends Node

onready var grub_scene = preload("res://Enemy_Grub.tscn")
onready var fly_scene = preload("res://Enemy_Fly.tscn")
onready var coin_obj = preload("res://Coin.tscn")

export (int) var food_count = 0				# The currency in which to feed the tama
export (int) var coin_count = 0

var all_grubs = []
var all_flys = []
var coins = []
var spawn_list
var coin_spawn_list

signal game_over

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	spawn_list = [$Fly_spawn1, $Fly_spawn2, $SpawnGrub_1]
	coin_spawn_list = $CoinPointContainer.get_children()
	self.connect( "game_over", self, "_handle_game_over")
	$HUD.connect( "restart", self, "_handle_restart_game" )
	$HUD.connect( "main_menu", self, "_handle_main_menu" )
	#$Minigame.connect( "end_minigame", self, "_handle_end_minigame")
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
	match button_type:
		0:
			if (food_count > 0):
				food_count = food_count - 1
				$HUD.update_score(food_count)
				$Tama.food(1)
		1:
			#print("this is the play button")
			pass
	
func _on_SpawnTimer_timeout():
	randomize()
	if all_flys.size() < 5 && randi()%2 == 1:
		var fly_instance = fly_scene.instance()
		fly_instance.connect("enemy_died", self, "_on_enemy_dies")
		var i = spawn_list[randi()%3]
		fly_instance.position = i.position
		add_child(fly_instance)
		all_flys.push_back(fly_instance)
		
func _handle_coin():
	if coins.size() < 5 && randi()%2 == 1:
		var index = randi()%coin_spawn_list.size()
		var coin_instance = coin_obj.instance()
		coin_instance.position = coin_spawn_list[index].position
		add_child(coins)
		coins.push_back(coin_instance)

func _handle_restart_game():
	print("handling retry")
	for coin in coins:		#erase all coins in the list
		coins.erase(coin)
		
	for fly in all_flys:		#erase all flies in the list
		all_flys.erase(fly)
		
	for grub in all_grubs:		#erase all grubs in the list
		all_grubs.erase(grub)
	
	coin_count = 0
	food_count = 0
	#$HUD.emit_signal("restart")
	pass
	
func _handle_main_menu():
	print("handling main menu")
	#$HUD.emit_signal("main_menu")
	pass
	
func _handle_game_over():
	$HUD.emit_signal("game_over")
		
func _on_enemy_dies(enemy):
	$HitSound.play()
	food_count = food_count + 3
	$HUD.update_score(food_count)
	if "Enemy_Fly" in enemy.get_name():
		all_flys.erase(enemy)
	elif "Enemy_Grub" in enemy.get_name():
		all_grubs.erase(enemy)

func _on_pick_up_coin(coin):
	coin_count = coin_count + 1
	coins.erase(coin)
		
func _on_Tama_change_animation(animation):
	$TamaAnimatedSprite.play(animation)
	
func _handle_end_minigame():
	pass

func _on_Tama_tama_update(happiness, hungriness):
	$HUD.update_happy_hunger(happiness, hungriness)

func _on_Tama_tama_died():
	emit_signal("game_over")
