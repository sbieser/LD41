extends KinematicBody2D

#if anything outside of this class needs to know if the player was hit, it could connect to this
signal hit
signal button_pressed(button_type)
signal coin_collected(coin)

export (int) var jump_speed = -200
export (int) var gravity = 500
export (int) var run_speed = 100
export (int) var walk_speed = 85
export (int) var facing = 0

#TODO: We need to have states to show which direction the player is facing, left or right
enum {IDLE, JUMP, ATTACK, WALK, CROUCH_IDLE, CROUCH_WALK, STUNNED, STUNNED_IDLE}
enum {RIGHT_FACING, LEFT_FACING}
var velocity = Vector2()
var state
var anim
var new_anim

var hit_bodies = [] #array of bodies hit by the current attack
var hit_enemies = [] #array of enemies hit by the current attack
var hit_buttons = [] #array of buttons hit by the current attack

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	$AttackArea.visible = false
	change_state(IDLE)

func change_direction():
	if velocity.x < 0:
		facing = LEFT_FACING
	else:
		facing = RIGHT_FACING

func change_state(new_state):
	#print("change_state")
	if new_state != state:
		state = new_state
		match state:
			IDLE:
				new_anim = "idle"
			CROUCH_IDLE:
				new_anim = "duck"
			WALK:
				new_anim = "walk"
			CROUCH_WALK:
				new_anim = "duck"
			ATTACK:
				new_anim = "new_attack"
				$AttackArea.visible = true
			JUMP:
				new_anim = "jump"
	
	if state == WALK or state == CROUCH_WALK:
		change_direction()
	
	#change player size based on standing or crouching
	if state == CROUCH_IDLE or state == CROUCH_WALK:
		$CollisionShape2D.shape.set_extents(Vector2(16,16))
		$CollisionShape2D.position = Vector2(0,16)
	else:
		if new_anim == "new_attack":
			if facing == LEFT_FACING:
				$AnimatedSprite.position = Vector2(-16,0)
			else:
				$AnimatedSprite.position = Vector2(16,0)
		else:
			$AnimatedSprite.position = Vector2(0,0)
		$CollisionShape2D.shape.set_extents(Vector2(14,30))
		$CollisionShape2D.position = Vector2(0,0)
	
	if facing == LEFT_FACING:
		$AnimatedSprite.flip_h = true
		if state == CROUCH_WALK or state == CROUCH_IDLE:
			get_node("AttackArea/CollisionShape2D").position = Vector2(-32,16)
			get_node("AttackArea/CollisionShape2D").shape.set_extents(Vector2(16,16))
		else:
			get_node("AttackArea/CollisionShape2D").position = Vector2(-32,0)
			get_node("AttackArea/CollisionShape2D").shape.set_extents(Vector2(16,32))
	else:
		$AnimatedSprite.flip_h = false
		if state == CROUCH_WALK or state == CROUCH_IDLE:
			get_node("AttackArea/CollisionShape2D").position = Vector2(32,16)
			get_node("AttackArea/CollisionShape2D").shape.set_extents(Vector2(16,16))
		else:
			get_node("AttackArea/CollisionShape2D").position = Vector2(32,0)
			get_node("AttackArea/CollisionShape2D").shape.set_extents(Vector2(16,32))

	
func handle_horizontal_movement():
	var right = Input.is_action_pressed("ui_right") #movement right
	var left = Input.is_action_pressed("ui_left") # movement left
	var down = Input.is_action_pressed("ui_down") # crouch button
	
	var cur_speed = walk_speed
	if down:
		cur_speed = walk_speed / 2
	if right:
		velocity.x += cur_speed
	if left:
		velocity.x -= cur_speed

func handle_action():
	pass
	
	
func print_state():
	match state:
		IDLE:
			print("IDLE")
		JUMP:
			print("JUMP")
		ATTACK:
			print("ATTACK")
		WALK:
			print("WALK")
		CROUCH_IDLE:
			print("CROUCH_IDLE")
		CROUCH_WALK:
			print("CROUCH_WALK")

func handle_input():
	
	#Left/Right - Move
	#Up         - Look up / Climb
	#Down       - Look down / Crouch / Climb / Run (If down-for-running is enabled)
	#X          - Action
	#Z          - Jump
	var right = Input.is_action_pressed("ui_right") #movement right
	var left = Input.is_action_pressed("ui_left") # movement left
	var down = false#Input.is_action_pressed("ui_down") # crouch button
	var x = Input.is_action_just_pressed("ui_x")
	var z = Input.is_action_pressed("ui_z") # jump button
	
	#set velocity to 0 initially
	velocity.x = 0
	handle_horizontal_movement() #find horizontal movememnt through left and right inputs
	
	match state:
		IDLE:
			if velocity.x != 0:
				change_state(WALK)
			elif z and is_on_floor():
				velocity.y = jump_speed
				change_state(JUMP)
			elif down:
				change_state(CROUCH_IDLE)
			elif x and state != ATTACK:
				change_state(ATTACK)
		CROUCH_IDLE:
			if velocity.x != 0:
				change_state(CROUCH_WALK)
			elif z and is_on_floor():
				velocity.y = jump_speed
				change_state(JUMP)
			elif not down:
				if velocity.x != 0:
					change_state(WALK)
				else:
					change_state(IDLE)
		CROUCH_WALK:
			if not down:
				if velocity.x != 0:
					change_state(WALK)
				else:
					change_state(IDLE)
			elif velocity.x == 0:
				change_state(CROUCH_IDLE)
			elif z and is_on_floor():
				velocity.y = jump_speed
				change_state(JUMP)
		WALK:
			if down:
				if velocity.x != 0:
					change_state(CROUCH_WALK)
				else:
					change_state(CROUCH_IDLE)
			elif z and is_on_floor():
				velocity.y = jump_speed
				change_state(JUMP)
			elif velocity.x == 0:
				change_state(IDLE)
		JUMP:
			if x and state != ATTACK:
				change_state(ATTACK)
		ATTACK:
			pass
	
func _process(delta):
	handle_input()
	
	if new_anim != anim:
		anim = new_anim
		$AnimatedSprite.play(anim)
		if anim == "new_attack":
			get_node("AttackArea/AttackTimer").start()
		
func _physics_process(delta):
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2(0,-1))
	
	match state:
		JUMP:
			if is_on_floor():
				if velocity.x != 0:
					change_state(WALK)
				else:
					change_state(IDLE)
					
	
	var collected_areas = $CollectionArea.get_overlapping_areas()
	for collected_area in collected_areas:
		if collected_area.is_in_group("coin"):
			emit_signal("coin_collected", collected_area)
	
	#check attacking
	if state == ATTACK:
		#var bodies = $AttackArea.get_overlapping
		var bodies = $AttackArea.get_overlapping_bodies()
		for body in bodies:
			if body.is_in_group("enemy") and not hit_bodies.has(body):
				hit_bodies.append(body)
				body.hit_detected()
		#check areas
		var areas = $AttackArea.get_overlapping_areas()
		for area in areas:
			#if area.is_in_group("enemy") and not hit_enemies.has(area):
			#	print("hit enemy")
			#	hit_enemies.append(area)
			#	area.hit_detected()
			#	emit_signal("hit")
			if area.is_in_group("button") and not hit_buttons.has(area):
				hit_buttons.append(area)
				emit_signal("button_pressed", area.get_parent().type)
		
				
				
	#check if stunned			
	#var collision_count = get_slide_count()
	#if collision_count > 0:
	#	for i in range(collision_count):
	#		var collision = get_slide_collision(i)
#			if collision.collider.is_in_group("enemy"):
#				change_state(STUNNED)
#				print("we have been hit by: " + collision.collider.name)
#				velocity.y = jump_speed
#				velocity.x = -velocity.x
#
#	if state == STUNNED:
#		if is_on_floor():
#			change_state(STUNNED_IDLE)
#			$StunIdleTimer.start()
				
				
	#if attacking:
	#	var bodies = $AttackArea.get_overlapping_bodies()
	#	for body in bodies:
	#		if body.is_in_group("enemies") and not hit_bodies.has(body):
	#			hit_bodies.append(body)
	#			body._takeDamage(5)
	#
	#velocity.y += gravity * delta
	#if state == JUMP:
	#	if is_on_floor():
	#		change_state(IDLE)
	#
	#trigger the stun timer when the player has hit the floor
	#if state == STUNNED:
	#	if is_on_floor():
	#		change_state(STUNNED_IDLE)
	#		#$StunIdleTimer.start()
	#	
	#var collision_count = get_slide_count()
	#if collision_count > 0:
	#	for i in range(collision_count):
	#		var collision = get_slide_collision(i)
	#		if collision.collider.is_in_group("enemies"):
	#			change_state(STUNNED)
	#			#print("we have been hit by: " + collision.collider.name)
	#			velocity.y = jump_speed
	#			velocity.x = -velocity.x
	#			

#func _on_StunTimer_timeout():
#	#pass # replace with function body
#	$StunIdleTimer.stop()
#	change_state(IDLE)

#func _on_AnimatedSprite_animation_finished():
	#pass
#	if anim == "new_attack":
#		print("_on_AnimatedSprite_animation_finished")
#		#$AnimatedSprite.frame = 0
#		if is_on_floor():
#			change_state(IDLE)
#		else:
#			change_state(JUMP)
	#print("_on_AnimatedSprite_animation_finished")
	#pass
	#when finished with the attack animation
#	if anim == "new_attack":
#		if is_on_floor():
#			change_state(IDLE)
#		else:
#			change_state(JUMP)
#		print("attack animation finished")
#		print($AnimatedSprite.frame)
#		hit_bodies.clear()
#		hit_enemies.clear()
#		hit_buttons.clear()
		
func _on_AttackTimer_timeout():
	get_node("AttackArea/AttackTimer").stop()
	if is_on_floor():
		change_state(IDLE)
	else:
		change_state(JUMP)
	hit_bodies.clear()
	hit_enemies.clear()
	hit_buttons.clear()
