extends Node

var score: int = 0
@onready var inventory: Control = $UI/Inventory

func _ready() -> void:
    # Listen for coin pickups
    for coin in get_tree().get_nodes_in_group("coin"):
        coin.collected.connect(_on_coin_collected)
    
    # Debug: Check if inventory is properly connected
    print("GameManager ready. Inventory node: ", inventory)
    if inventory == null:
        print("ERROR: Inventory not found! Check scene structure.")
    
    # Add some test items to inventory after a short delay
    call_deferred("setup_test_inventory")

func _on_coin_collected() -> void:
    score += 1
    $UI/ScoreLabel.text = "Score: %d" % score

func setup_test_inventory():
    # Wait for inventory to be ready
    await get_tree().process_frame
    
    if inventory == null:
        print("ERROR: Cannot setup inventory - inventory node is null")
        return
    
    print("Setting up test inventory...")
    
    # Add some test items to demonstrate the inventory system
    inventory.add_item(ItemDatabase.create_item("pistol"))
    inventory.add_item(ItemDatabase.create_item("medical_kit"))
    inventory.add_item(ItemDatabase.create_item("tactical_helmet"))
    inventory.add_item(ItemDatabase.create_item("keycard"))
    inventory.add_item(ItemDatabase.create_item("grenade"))
    inventory.add_item(ItemDatabase.create_item("kevlar_vest"))
    
    print("Inventory system ready! Press 'I', 'Tab', or 'Esc' to open inventory.") 