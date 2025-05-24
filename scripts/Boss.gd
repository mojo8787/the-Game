extends CharacterBody2D

@export var health: int = 10
@export var speed: float = 80.0
@export var gravity: float = 900.0

var player: CharacterBody2D

func _ready() -> void:
    player = get_tree().get_first_node_in_group("player") as CharacterBody2D

func _physics_process(delta: float) -> void:
    velocity.y += gravity * delta

    if player:
        var dir_sign: float = sign(player.global_position.x - global_position.x)
        velocity.x = dir_sign * speed

    move_and_slide()

func take_damage(amount: int = 1) -> void:
    health -= amount
    if health <= 0:
        queue_free() 