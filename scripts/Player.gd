extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_velocity: float = -400.0
@export var gravity: float = 900.0

func _physics_process(delta: float) -> void:
	var dir := Input.get_axis("move_left", "move_right")
	velocity.x = dir * speed

	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	move_and_slide()

	if position.y > 1000:  # Fell into the void → restart level
		get_tree().reload_current_scene()

func _on_hurtbox_body_entered(body: Node) -> void:
	if body.is_in_group("enemy"):
		# Simple damage → restart level
		get_tree().reload_current_scene() 
