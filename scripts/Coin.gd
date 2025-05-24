extends Area2D

signal collected

@onready var pickup_audio: AudioStreamPlayer = $PickupAudio

func _ready() -> void:
    body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
    if body.is_in_group("player"):
        emit_signal("collected")
        pickup_audio.play()
        # Hide the coin visually but wait for audio to finish
        $Sprite2D.visible = false
        $CollisionShape2D.disabled = true
        # Wait for audio to finish then free the node
        pickup_audio.finished.connect(queue_free) 