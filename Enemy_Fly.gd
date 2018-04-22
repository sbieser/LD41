extends KinematicBody2D

const Player = preload("Player.gd")


signal hit
signal enemy_died

export (int) var SPEED = 3
var hitpoint = 1
var direction = "left"


# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	print(self.position)
	move_fly()

func _process(delta):
	if hitpoint > 0 :
		move_fly()

func remove_enemy():
	queue_free()
	emit_signal("enemy_died")
	
func hit_detected():
	hitpoint = hitpoint -1
	emit_signal("hit")
	
	if hitpoint < 1:
		remove_enemy()

func move_fly():
	if direction == "right":
		self.position = Vector2( self.position.x + SPEED, self.position.y);
	else:
		#self.set_linear_velocity(Vector2(-SPEED, 0));
		self.position = Vector2( self.position.x - SPEED, self.position.y);
		

func _on_LeftSide_body_entered(body):
	if body is TileMap || body is Player:
		direction = "right"


func _on_RightSide_body_entered(body):
	if body is TileMap || body is Player:
		direction = "left"