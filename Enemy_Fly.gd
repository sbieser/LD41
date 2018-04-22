extends Area2D

signal hit

export (int) var SPEED = 1
var hitpoint = 1
var direction = "left"


# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	print(self.position)
	move()

func _process(delta):
	if hitpoint > 0 :
		move()

func remove_enemy():
	queue_free()
	
func hit_detected():
	hitpoint = hitpoint -1
	
	if hitpoint < 1:
		remove_enemy()

func _on_Enemy_Fly_body_entered(body):
	emit_signal("hit")
	
	if body is TileMap:
		if direction == "left":
			direction = "right"
		else: 
			direction = "left"
		
		move()

func move():
	if direction == "right":
		self.position = Vector2( self.position.x + SPEED, self.position.y);
	else:
		#self.set_linear_velocity(Vector2(-SPEED, 0));
		self.position = Vector2( self.position.x - SPEED, self.position.y);
		