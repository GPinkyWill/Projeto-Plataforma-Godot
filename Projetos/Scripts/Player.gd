extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping := false
var is_hurt := false
var player_life := 10
var knockback_vector := Vector2.ZERO
var direction 
 

@onready var animation := $AnimatedSprite2D as AnimatedSprite2D
@onready var remote_transform := $remote as RemoteTransform2D
@onready var ray_rigth := $ray_right as RayCast2D
@onready var ray_left :=$ray_left as RayCast2D


func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		is_jumping = true
		

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jumping = true
	elif is_on_floor():
		is_jumping = false
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("ui_left", "ui_right")
	
	if !is_hurt:
		if direction !=0:
			velocity.x = direction * SPEED
			animation.scale.x = direction
		
		
				
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
	_set_state()
	move_and_slide()

	for Platfmors in get_slide_collision_count():
		var collision = get_slide_collision(Platfmors)
		if collision.get_collider().has_method("has_collided_with"):
			collision.get_collider().has_collided_with(collision, self)




func _on_hurtbox_body_entered(body):
	
	
	if player_life == 0:
		
		queue_free()
	else:
		if ray_rigth.is_colliding():
			
			take_damage(Vector2(-200,-200))
			
			
			
		elif ray_left.is_colliding():
			
			take_damage(Vector2(200,-200))
			
			
		
		
		
func follow_camera(camera):
	var camera_path =  camera.get_path()
	remote_transform.remote_path = camera_path
func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	player_life -= 1
	
	
	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force
		
		
		
		var knockback_tween := get_tree().create_tween()
		knockback_tween.parallel().tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		animation.modulate = Color(1,0,0,1)
		knockback_tween.parallel().tween_property(animation,"modulate",Color(1,1,1,1),duration)
		
		is_hurt = true
		await get_tree().create_timer(.5).timeout
		is_hurt = false
		
func _set_state():
	var state = "Idle"
	if !is_on_floor():
		state ="Jump"
	elif direction != 0:
		state ="Run"
	if is_hurt:
		state = "Hurt"
		
	if animation.name != state:
		animation.play(state)
		


	




func _on_head_collider_body_entered(body):
	if body.has_method("break_sprite"):
		body.hitpoints -= 1
		if body.hitpoints < 1:
			body.break_sprite()
		else:
			body.animation_player.play("hit")
			if body.have_coins == true:
				body.create_coin()
		
