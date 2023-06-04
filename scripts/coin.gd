extends Area2D

@onready var coin_animator := $coin_animator as AnimatedSprite2D

func _on_body_entered(_body):
	coin_animator.play("collect")

func _on_coin_animator_animation_finished():
	queue_free()
