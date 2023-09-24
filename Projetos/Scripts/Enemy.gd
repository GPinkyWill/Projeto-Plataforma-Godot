extends CharacterBody2D


const SPEED = 1400.0
const JUMP_VELOCITY = -400.0
var direction := -1
var duration := 0.25
@onready var wall_Detector := $Wall_Detector as RayCast2D
@onready var texture := $Texture as Sprite2D
@onready var anim := $Anim as AnimationPlayer
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
		
	if wall_Detector.is_colliding():
		
		direction *= -1
		wall_Detector.scale.x *= -1
	if direction == 1:
		texture.flip_h = true
	else: 
		texture.flip_h = false
	# Handle Jump.


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	velocity.x = direction * SPEED * delta
	

	move_and_slide()


func _on_anim_animation_finished(anim_name):
	if anim_name == "Hurt":
		queue_free()
		


func _on_anim_animation_started(anim_name):
	if anim_name == "Hurt":
		
		var enemy_tween = get_tree().create_tween()
		enemy_tween.tween_property(texture,"modulate",Color(1,0,0,1),duration)
