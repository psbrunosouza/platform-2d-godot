extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping := false
var knockback_vector := Vector2.ZERO

@export var life := 10

@onready var animation := $anim as AnimatedSprite2D
@onready var remote_transform := $remote as RemoteTransform2D
@onready var knockback_ray_collider_left := $ray_left
@onready var knockback_ray_collider_right := $ray_right

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jumping = true
	elif is_on_floor():
		is_jumping = false

	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction != 0:
		velocity.x = direction * SPEED
		animation.scale.x = direction
		if not is_jumping:
			animation.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animation.play("idle")
		
	if is_jumping:
		animation.play("jump")
		
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector

	move_and_slide()


func _on_hurtbox_body_entered(body):
	if life <= 0:
		queue_free()
	else:
		if knockback_ray_collider_left.is_colliding():
			take_damage(Vector2(-200, -200))
		elif knockback_ray_collider_right.is_colliding():
			take_damage(Vector2(200, -200))
		
func take_damage(knockback_force := Vector2.ZERO, duration := 0.25): 
	life -= 1
	
	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force 
		
		var knockback_tween := get_tree().create_tween()
		knockback_tween.parallel().tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		animation.modulate = Color(1, 0, 0, 1)
		knockback_tween.parallel().tween_property(animation, "modulate", Color(1, 1, 1, 1), duration)
		
func follow_camera(camera): 
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path
