extends Area2D

func _on_body_entered(body):
	if body.name == "player":
		owner.anim.play("hurt")
		body.velocity.y = body.JUMP_VELOCITY 
		
