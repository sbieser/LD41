extends KinematicBody2D

onready var main = preload("res://Main.gd")

signal hit
signal enemy_died(enemy)
signal changed_directions

export (float) var SPEEDX = 1
var gravity = 500
var hitpoint = 1
var direction = "left"
var velocity = Vector2()
const points = 5


# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	randomize()
	if (randi()%11 + 1) > 4 :
		direction = "right"
	else:
		direction = "left"
		
	move_directions()
	
	self.connect("hit", self, "hit_detected")
	#$Left_side.connect("hit", self, "hit_detected")
	#$Right_side.connect("hit", self, "hit_detected")
	#$Body.connect("hit", self, "hit_detected")

func _process(delta):
	if hitpoint > 0:
		move_directions()

func _physics_process(delta):
	velocity.y += gravity * delta	
	velocity = move_and_slide(velocity, Vector2(0,-1))
	
func remove_enemy(died_by_hit):
	queue_free()
	if died_by_hit:
		emit_signal("enemy_died", self)
	
func hit_detected():
	hitpoint = hitpoint - 1
	
	if hitpoint < 1:
		remove_enemy(true)

func move_directions():
	if direction == "right":
		$AnimatedSprite.flip_h = true
		position = Vector2(self.position.x + SPEEDX, self.position.y)
	else:
		$AnimatedSprite.flip_h = false
		self.position = Vector2(self.position.x - SPEEDX, self.position.y)


func _on_Left_side_body_entered(body):
	if body is TileMap:
		direction = "right"


func _on_Right_side_body_entered(body):
	if body is TileMap:
		direction = "left"
