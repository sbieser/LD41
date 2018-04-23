extends CanvasLayer

onready var main = preload("res://Main.gd")

signal game_over
signal main_menu
signal restart
 
var game = false

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	self.connect("game_over", self, "handle_game_over" )
	self.connect("restart", self, "start_game")
	self.connect("main_menu", self, "main_menu")
	

func _process(delta):
	if game:
		game_over_input()

func update_score(score):
	$FoodCount.text = str(score)

func update_coin(coin):
	$CoinCount.text = str(coin)

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
	$QuitLabel.visible = false
	$RetryLabel.visible = false
	$GameOverLabel.visible = false
	$FoodLabel.visible = false
	$FoodCount.visible = false
	$HungerLabel.visible = false
	$HappyLabel.visible = false
	game = false
	
func start_game():
	print("triggered?")
	update_score(0)
	$QuitLabel.visible = false
	$RetryLabel.visible = false
	$GameOverLabel.visible = false
	$FoodLabel.visible = true
	$FoodCount.visible = true
	$HungerLabel.visible = true
	$HappyLabel.visible = true
	game = false
	
func handle_game_over():
	$QuitLabel.visible = true
	$RetryLabel.visible = true
	$GameOverLabel.visible = true
	$FoodLabel.visible = false
	$FoodCount.visible = false
	$HungerLabel.visible = false
	$HappyLabel.visible = false
	$QuitLabel.set("custom_colors/font_color", "FFFFFF")
	$RetryLabel.set("custom_colors/font_color", "333333")
	game = true

func game_over_input():
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left")
	var enter = Input.is_action_pressed("ui_accept")
	
	if right:
		$QuitLabel.set("custom_colors/font_color", "333333")
		$RetryLabel.set("custom_colors/font_color", "FFFFFF")
	elif left:
		$QuitLabel.set("custom_colors/font_color", "FFFFFF")
		$RetryLabel.set("custom_colors/font_color", "333333")
	elif enter:
		if $QuitLabel.get("custom_colors/font_color") == Color("333333"):
			emit_signal("main_menu")
		elif $RetryLabel.get("custom_colors/font_color") == Color("333333"):
			emit_signal("restart")
		game = false
		pass
