extends Node

var score: int = 0
@onready var inventory: Control = $UI/Inventory

func _ready() -> void:
    # Listen for coin pickups
    for coin in get_tree().get_nodes_in_group("coin"):
        coin.collected.connect(_on_coin_collected)
    
    # Add some test items to inventory after a short delay
    call_deferred("setup_test_inventory")

func _on_coin_collected() -> void:
    score += 1
    $UI/ScoreLabel.text = "Score: %d" % score

func setup_test_inventory():
    # Wait for inventory to be ready
    await get_tree().process_frame
    
    # Add some test items to demonstrate the inventory system
    inventory.add_item(ItemDatabase.create_item("pistol"))
    inventory.add_item(ItemDatabase.create_item("medical_kit"))
    inventory.add_item(ItemDatabase.create_item("tactical_helmet"))
    inventory.add_item(ItemDatabase.create_item("keycard"))
    inventory.add_item(ItemDatabase.create_item("grenade"))
    inventory.add_item(ItemDatabase.create_item("kevlar_vest"))
    
    print("Inventory system ready! Press 'I', 'Tab', or 'Esc' to open inventory.") 