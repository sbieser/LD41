extends Node2D

enum TYPE {FOOD,PLAY}
export(TYPE) var type

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	if type == FOOD:
		$Area2D/Sprite.set_texture(load("res://textures/buttons/food_btn.png"))
	elif type == PLAY:
		$Area2D/Sprite.set_texture(load("res://textures/buttons/play_btn.png"))
