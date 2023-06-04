extends CharacterBody2D

@onready var sprite = $sprite as Sprite2D
@onready var wall_detector = $wall_detector as RayCast2D
@onready var anim = $anim

const SPEED = 700.0
const JUMP_VELOCITY = -400.0

var direction := -1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	wall_detector.target_position.x *= -1

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if wall_detector.is_colliding():
		direction *= -1
		wall_detector.target_position.x *= -1

	if direction:
		velocity.x = direction * SPEED * delta
		sprite.scale.x = direction

	move_and_slide()

func _on_anim_animation_finished(anim_name):
	if anim_name == "hurt":
		queue_free()
