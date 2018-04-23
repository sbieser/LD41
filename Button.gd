extends Node2D

enum TYPE {FOOD,PLAY}
export(TYPE) var type

signal restart
signal game_over

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	if type == FOOD:
		$Area2D/Sprite.set_texture(load("res://textures/buttons/food_btn.png"))
	elif type == PLAY:
		$Area2D/Sprite.set_texture(load("res://textures/buttons/play_btn.png"))
		
	connect("restart", self, "_on_restart")
	connect("game_over", self, "_on_game_over")
	
func _on_restart():
	self.visible = true

func _on_game_over():
	self.visible = false
