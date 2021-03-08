extends KinematicBody2D

var velocity = Vector2()
export var direction = -1
export var detect_cliff = true
var Speed = 50

func _ready():
	if direction == 1:
		$AnimatedSprite.flip_h = true
	$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	$floor_checker.enabled = detect_cliff
	if detect_cliff:
		set_modulate(Color(1,0.2,0.3))
	
func _physics_process(delta):
	
	if is_on_wall() or not $floor_checker.is_colliding() and detect_cliff and is_on_floor():
		direction = direction * -1
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
		$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	
	velocity.y += 20
	
	velocity.x = Speed * direction
	
	velocity = move_and_slide(velocity,Vector2.UP)
	
	


func _on_top_checker_body_entered(body):
	$AnimatedSprite.play("squashed")
	Speed = 0
	set_collision_layer_bit(4,false)
	set_collision_mask_bit(0,false)
	$top_checker.set_collision_layer_bit(4,false)
	$top_checker.set_collision_mask_bit(0,false)
	$sides_ckecker.monitoring = false		# use this
	#$sides_ckecker.set_collision_layer_bit(4,false)  "dont use this"
	#$sides_checker.set_collision_mask_bit(0,false)
	$Timer.start()
	body.bounce()
	
	
func _on_sides_ckecker_body_entered(body):
	print("hurt")
	body.ouch(position.x)
	#get_tree().change_scene("res://scenes/Level_1.tscn")


func _on_Timer_timeout():
	queue_free()
