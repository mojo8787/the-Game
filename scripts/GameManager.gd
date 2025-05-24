extends Node

var score: int = 0

func _ready() -> void:
    # Listen for coin pickups
    for coin in get_tree().get_nodes_in_group("coin"):
        coin.collected.connect(_on_coin_collected)

func _on_coin_collected() -> void:
    score += 1
    $UI/ScoreLabel.text = "Score: %d" % score 