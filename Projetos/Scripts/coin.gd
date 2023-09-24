extends Area2D
@onready var animation := $Moeda as AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	
	animation.play("Collect")
	


func _on_moeda_animation_finished():
	queue_free()
