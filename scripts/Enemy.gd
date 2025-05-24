extends CharacterBody2D

@export var speed: float = 100.0
@export var gravity: float = 900.0
var direction: int = 1

func _physics_process(delta: float) -> void:
    velocity.y += gravity * delta
    velocity.x = speed * direction

    if is_on_wall():
        direction *= -1  # Turn around on walls/ledges

    move_and_slide() 