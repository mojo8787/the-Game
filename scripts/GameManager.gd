extends Node

var score: int = 0
@onready var inventory: Control = $UI/Inventory

func _ready() -> void:
    # Listen for coin pickups
    for coin in get_tree().get_nodes_in_group("coin"):
        coin.collected.connect(_on_coin_collected)
    
    # Add some test items to inventory after a short delay
    call_deferred("setup_test_inventory")

func _input(event):
    if event is InputEventKey and event.pressed:
        # Manual key checking for inventory
        if event.keycode == KEY_I or event.physical_keycode == KEY_I:
            toggle_inventory()
        elif event.keycode == KEY_TAB or event.physical_keycode == KEY_TAB:
            toggle_inventory()
        elif event.keycode == KEY_ESCAPE or event.physical_keycode == KEY_ESCAPE:
            toggle_inventory()

func toggle_inventory():
    if inventory == null:
        return
    
    if inventory.has_method("toggle_inventory"):
        inventory.toggle_inventory()

func _on_coin_collected() -> void:
    score += 1
    $UI/ScoreLabel.text = "Score: %d" % score

func setup_test_inventory():
    # Wait for inventory to be ready
    await get_tree().process_frame
    
    if inventory == null:
        return
    
    # Add some test items to demonstrate the inventory system
    inventory.add_item(ItemDatabase.create_item("pistol"))
    inventory.add_item(ItemDatabase.create_item("medical_kit"))
    inventory.add_item(ItemDatabase.create_item("tactical_helmet"))
    inventory.add_item(ItemDatabase.create_item("keycard"))
    inventory.add_item(ItemDatabase.create_item("grenade"))
    inventory.add_item(ItemDatabase.create_item("kevlar_vest")) 