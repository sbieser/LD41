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
	
	self.connect( "game_over", self, "handle_game_over" )
	self.connect( "restart", self, "start_game")
	self.connect( "main_menu", self, "main_menu")
	

func _process(delta):
	if game:
		game_over_input()

func update_score(score):
	$FoodCount.text = str(score)
	
func main_menu():
	$QuitLabel.visible = false
	$RetryLabel.visible = false
	$GameOverLabel.visible = false
	$FoodLabel.visible = false
	$FoodCount.visible = false
	game = false
	
func start_game():
	update_score(0)
	$QuitLabel.visible = false
	$RetryLabel.visible = false
	$GameOverLabel.visible = false
	$FoodLabel.visible = true
	$FoodCount.visible = true
	game = false
	
func handle_game_over():
	$QuitLabel.visible = true
	$RetryLabel.visible = true
	$GameOverLabel.visible = true
	$FoodLabel.visible = false
	$FoodCount.visible = false
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
	else:
		main.emit_signal("main_menu")
		main.emit_signal("retry")
		pass
