extends CanvasLayer

onready var main = preload("res://Main.gd")

signal game_over
signal main_menu
signal restart
signal start_game
 
var game = false
var start = false

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	self.connect("game_over", self, "handle_game_over" )
	self.connect("restart", self, "start_game")
	self.connect("main_menu", self, "main_menu")
	self.connect("start_game", self, "start_game")


func _process(delta):
	if !start:
		start_game_input()
	elif game:
		game_over_input()

func update_score(score):
	$FoodCount.text = str(score)

func update_coin(coin):
	$CoinCount.text = str(coin)
	
func update_timer(sec):
	$TimerBorder/TimerColor/TimerLabel.text = str(sec)

func update_happy_hunger(happiness,hungriness):
	#print("update_happy_hunger " + str(happiness) + ":" + str(hungriness))
	#update the happy meter
	if happiness >= 3:
		$HappyLabel/HappyFull1.visible = true
		$HappyLabel/HappyFull2.visible = true
		$HappyLabel/HappyFull3.visible = true
	elif happiness >= 2:
		$HappyLabel/HappyFull1.visible = true
		$HappyLabel/HappyFull2.visible = true
		$HappyLabel/HappyFull3.visible = false
	elif happiness >= 1:
		$HappyLabel/HappyFull1.visible = true
		$HappyLabel/HappyFull2.visible = false
		$HappyLabel/HappyFull3.visible = false
	else:
		$HappyLabel/HappyFull1.visible = false
		$HappyLabel/HappyFull2.visible = false
		$HappyLabel/HappyFull3.visible = false
	
	if hungriness >= 3:
		$HungerLabel/HungerFull1.visible = true
		$HungerLabel/HungerFull2.visible = true
		$HungerLabel/HungerFull3.visible = true
		$HungerLabel/HungerEmpty1.visible = false
		$HungerLabel/HungerEmpty2.visible = false
		$HungerLabel/HungerEmpty3.visible = false
	elif hungriness >= 2:
		$HungerLabel/HungerFull1.visible = true
		$HungerLabel/HungerFull2.visible = true
		$HungerLabel/HungerFull3.visible = false
		$HungerLabel/HungerEmpty1.visible = false
		$HungerLabel/HungerEmpty2.visible = false
		$HungerLabel/HungerEmpty3.visible = true
	elif hungriness >= 1:
		$HungerLabel/HungerFull1.visible = true
		$HungerLabel/HungerFull2.visible = false
		$HungerLabel/HungerFull3.visible = false
		$HungerLabel/HungerEmpty1.visible = false
		$HungerLabel/HungerEmpty2.visible = true
		$HungerLabel/HungerEmpty3.visible = true
	else:
		$HungerLabel/HungerFull1.visible = false
		$HungerLabel/HungerFull2.visible = false
		$HungerLabel/HungerFull3.visible = false
		$HungerLabel/HungerEmpty1.visible = true
		$HungerLabel/HungerEmpty2.visible = true
		$HungerLabel/HungerEmpty3.visible = true
	
func main_menu():
	$FoodLabel.visible = false
	$FoodCount.visible = false
	$CoinCount.visible = false
	$CoinLabel.visible = false
	$HungerLabel.visible = false
	$HappyLabel.visible = false
	$BorderRect.visible = false
	$TimerBorder.visible = false
	game = false
	
func start_game():
	update_score(0)
	update_coin(0)
	update_happy_hunger(0, 0)
	update_timer(120)
	$FoodLabel.visible = true
	$FoodCount.visible = true
	$CoinCount.visible = true
	$CoinLabel.visible = true
	$HungerLabel.visible = true
	$HappyLabel.visible = true
	$BorderRect.visible = false
	$StartColorRect.visible = false
	$GameNameLabel.visible = false
	$TimerBorder.visible = true
	game = false
	
func handle_game_over(total):
	$BorderRect/MenuRect/TotalPointCount.text = str(total*100)
	$FoodLabel.visible = false
	$FoodCount.visible = false
	$CoinCount.visible = false
	$CoinLabel.visible = false
	$HungerLabel.visible = false
	$HappyLabel.visible = false
	$BorderRect.visible = true
	$TimerBorder.visible = false
	$BorderRect/MenuRect/QuitLabel.set("custom_colors/font_color", "306230")
	$BorderRect/MenuRect/RetryLabel.set("custom_colors/font_color", "FFFFFF")
	game = true
	
func start_game_input():
	var enter = Input.is_action_pressed("ui_accept")
	if enter:
		start = true
		emit_signal("restart")

func game_over_input():
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left")
	var enter = Input.is_action_pressed("ui_accept")
	
	if right:
		$BorderRect/MenuRect/QuitLabel.set("custom_colors/font_color", "FFFFFF")
		$BorderRect/MenuRect/RetryLabel.set("custom_colors/font_color", "306230")
	elif left:
		$BorderRect/MenuRect/QuitLabel.set("custom_colors/font_color", "306230")
		$BorderRect/MenuRect/RetryLabel.set("custom_colors/font_color", "FFFFFF")
	elif enter:
		if $BorderRect/MenuRect/QuitLabel.get("custom_colors/font_color") == Color("FFFFFF"):
			emit_signal("main_menu")
		elif $BorderRect/MenuRect/RetryLabel.get("custom_colors/font_color") == Color("FFFFFF"):
			emit_signal("restart")
		game = false
		pass
