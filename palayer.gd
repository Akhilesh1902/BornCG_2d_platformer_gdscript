extends KinematicBody2D

var velocity = Vector2(0,0)
const SPEED = 180
const GRAVITY = 30
const JUMP_FORCE = -1100
var coins = 0

func _physics_process(delta):
	if Input.is_action_pressed("right"):
		velocity.x = SPEED
		$Sprite.play("walk")
		$Sprite.flip_h = false
	elif Input.is_action_pressed("left"):
		velocity.x = -SPEED
		$Sprite.play("walk")
		$Sprite.flip_h = true
	else:
		$Sprite.play("idle")
		
	if not is_on_floor():
		$Sprite.play("air")
	
	velocity.y = velocity.y + GRAVITY
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_FORCE
		$Sprite.play("air")
	
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	velocity.x = lerp(velocity.x,0,0.2)

func _on_fall_zone_body_entered(body):
	if(body.get_name() == "Steve"):
		get_tree().change_scene("res://scenes/game_over.tscn")
		
func bounce():
	velocity.y = JUMP_FORCE * 0.6
	
func ouch(var enemy_posx):
	set_modulate(Color(1,0.3,0.3,0.6))
	velocity.y = JUMP_FORCE * 0.6
	if position.x < enemy_posx:
		velocity.x = -800
	elif position.x > enemy_posx:
		velocity.x = 800
	
	Input.action_release("left")
	Input.action_release("right")
	$Timer.start()


func _on_Timer_timeout():
	get_tree().change_scene("res://scenes/game_over.tscn")
