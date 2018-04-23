extends Node

onready var grub_scene = preload("res://Enemy_Grub.tscn")
onready var fly_scene = preload("res://Enemy_Fly.tscn")
onready var coin_scene = preload("res://Coin.tscn")

export (int) var food_count = 0				# The currency in which to feed the tama
export (int) var coin_count = 0				# The currency in which to play the tama

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
	coin_spawn_list = $CoinContainer.get_children()
	print(coin_spawn_list)
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
			#_handle_restart_game()
			if (coin_count > 0):
				coin_count = coin_count - 1
				$HUD.update_coin(coin_count)
				$Tama.happy(1)
			
	
func _on_SpawnTimer_timeout():
	randomize()
	if all_flys.size() < 5 && randi()%2 == 1:
		var fly_instance = fly_scene.instance()
		fly_instance.connect("enemy_died", self, "_on_enemy_dies")
		var i = spawn_list[randi()%3]
		fly_instance.position = i.position
		add_child(fly_instance)
		all_flys.push_back(fly_instance)

func _handle_restart_game():
	
	var _coins = get_tree().get_nodes_in_group("coin")
	for _coin in _coins:
   	 	_coin.queue_free()
		
	var _enemies = get_tree().get_nodes_in_group("enemy")
	for _enemy in _enemies:
   	 	_enemy.queue_free()
	
	all_grubs.clear()
	all_flys.clear()
	coins.clear()
	
#	for g in all_grubs:
#		g.queue_free()
#		all_grubs.erase(g)
#		#g.remove_enemy(false)
#
#	for f in all_flys:
#		all_flys.erase(f)
#		f.queue_free()
#
#	for c in coins:
#		c.queue_free()
#		coins.erase(c)

	$Coin_timer.start()
	$SpawnGrub_1/SpawnTimer.start()
	$Fly_spawn1/SpawnTimer.start()
		
	$Player.emit_signal("restart")
	$Tama.emit_signal("restart")
	#$HUD.emit_signal("restart")
	pass
	
func _handle_main_menu():
	print("handling main menu")
	#$HUD.emit_signal("main_menu")
	pass
	
func _handle_game_over():
	$Coin_timer.stop()
	$SpawnGrub_1/SpawnTimer.stop()
	$Fly_spawn1/SpawnTimer.stop()
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
	
func _handle_end_minigame():
	pass

func _on_Tama_tama_update(happiness, hungriness):
	$HUD.update_happy_hunger(happiness, hungriness)
	if happiness < 0:
		$TamaAnimatedSprite.play("baby_sad")
	elif hungriness < 0:
		$TamaAnimatedSprite.play("baby_hungry")
	else:
		$TamaAnimatedSprite.play("baby_idle")

func _on_Tama_tama_died():
	emit_signal("game_over")

func remove_coin(coin):
	coin_count = coin_count + 1
	$HUD.update_coin(coin_count)
	if coin in coins:
		coins.erase(coin)
		coin.queue_free()
	
func _on_Coin_Timer_timeout():
	randomize()
	if coins.size() < 5 && randi()%2 == 1:
		var coin_instance = coin_scene.instance()
		print(randi()%coin_spawn_list.size())
		var i = coin_spawn_list[randi()%coin_spawn_list.size()]
		coin_instance.position = i.position
		add_child(coin_instance)
		print(coin_instance)
		coins.push_back(coin_instance)

func _on_Player_coin_collected(coin):
	remove_coin(coin)
