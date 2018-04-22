extends KinematicBody2D

signal hit
signal enemy_died
signal changed_directions

export (float) var SPEEDX = 60
var gravity = 500
var hitpoint = 1
var direction = "left"
var velocity = Vector2()


# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	move_directions()

func _process(delta):
	if hitpoint > 0:
		move_directions()

func _physics_process(delta):
	velocity.y += gravity * delta	
	velocity = move_and_slide(velocity, Vector2(0,-1))
	
func remove_enemy():
	queue_free()
	emit_signal("enemy_died")
	
func hit_detected():
	hitpoint = hitpoint - 1
	emit_signal("hit")
	if hitpoint < 1:
		remove_enemy()

func move_directions():
	velocity.x = 0
	if direction == "right":
		velocity.x -= SPEEDX
		#self.position = Vector2(self.position.x + SPEEDX, self.position.y);
		#self.move_and_slide(Vector2(SPEED, 9.8), Vector2(0, 0))
	else:
		velocity.x += SPEEDX
		#self.set_linear_velocity(Vector2(-SPEED, 0));
		#self.position = Vector2(self.position.x - SPEEDX, self.position.y);
		#self.move_and_slide(Vector2(-SPEED, 9.8), Vector2(0, 0))
		

func _on_Area2D_body_entered(body):
	if direction == "left":
		direction = "right"
	else: 
		direction = "left"
