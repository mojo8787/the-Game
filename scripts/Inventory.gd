extends Control

signal item_selected(item: Item)
signal item_equipped(item: Item)
signal item_unequipped()

@export var inventory_size: int = 24
var items: Array[Item] = []
var selected_slot: int = 0
var is_open: bool = false

@onready var item_grid: GridContainer = $InventoryPanel/HBoxContainer/ItemGrid
@onready var item_name_label: Label = $InventoryPanel/HBoxContainer/ItemDetails/ItemName
@onready var item_description: RichTextLabel = $InventoryPanel/HBoxContainer/ItemDetails/ItemDescription
@onready var type_label: Label = $InventoryPanel/HBoxContainer/ItemDetails/ItemStats/TypeLabel
@onready var equippable_label: Label = $InventoryPanel/HBoxContainer/ItemDetails/ItemStats/EquippableLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Sound effects
var click_sound: AudioStreamPlayer
var equip_sound: AudioStreamPlayer
var unequip_sound: AudioStreamPlayer

var slots: Array[Control] = []

func _ready():
	# Initialize inventory with empty slots
	items.resize(inventory_size)
	
	# Create inventory slots
	for i in inventory_size:
		var slot = preload("res://scenes/InventorySlot.tscn").instantiate()
		slot.slot_index = i
		slot.slot_clicked.connect(_on_slot_clicked)
		slot.slot_hovered.connect(_on_slot_hovered)
		item_grid.add_child(slot)
		slots.append(slot)
	
	# Set initial selection
	update_selection()
	
	# Setup audio
	setup_audio()

func setup_audio():
	# Create audio players for sound effects
	click_sound = AudioStreamPlayer.new()
	equip_sound = AudioStreamPlayer.new()
	unequip_sound = AudioStreamPlayer.new()
	
	add_child(click_sound)
	add_child(equip_sound)
	add_child(unequip_sound)
	
	# Load sound effects (we'll use existing audio for now)
	# You can add specific inventory sounds later
	var jump_audio = load("res://assets/jump.wav")
	var coin_audio = load("res://assets/coin_pickup.wav")
	
	click_sound.stream = jump_audio
	equip_sound.stream = coin_audio
	unequip_sound.stream = jump_audio
	
	click_sound.volume_db = -15
	equip_sound.volume_db = -10
	unequip_sound.volume_db = -12

func toggle_inventory():
	if is_open:
		close_inventory()
	else:
		open_inventory()

func open_inventory():
	if is_open:
		return
		
	is_open = true
	visible = true
	get_tree().paused = true
	animation_player.play("open")
	update_display()

func close_inventory():
	if not is_open:
		return
		
	is_open = false
	get_tree().paused = false
	animation_player.play_backwards("open")
	await animation_player.animation_finished
	visible = false

func add_item(item: Item) -> bool:
	# Find first empty slot
	for i in range(items.size()):
		if items[i] == null:
			items[i] = item
			update_slot(i)
			return true
	return false  # Inventory full

func remove_item(slot_index: int) -> Item:
	if slot_index < 0 or slot_index >= items.size():
		return null
		
	var item = items[slot_index]
	items[slot_index] = null
	update_slot(slot_index)
	return item

func get_item(slot_index: int) -> Item:
	if slot_index < 0 or slot_index >= items.size():
		return null
	return items[slot_index]

func update_slot(slot_index: int):
	if slot_index < 0 or slot_index >= slots.size():
		return
		
	var slot = slots[slot_index]
	slot.set_item(items[slot_index])

func update_selection():
	# Update visual selection for all slots
	for i in range(slots.size()):
		slots[i].set_selected(i == selected_slot)
	
	# Update item details
	var selected_item = get_item(selected_slot)
	update_item_details(selected_item)

func update_item_details(item: Item):
	if item:
		item_name_label.text = item.name
		item_description.text = item.description
		
		var type_text = ""
		match item.type:
			Item.Type.WEAPON:
				type_text = "Type: Weapon"
			Item.Type.ARMOR:
				type_text = "Type: Armor"
			Item.Type.MEDICAL:
				type_text = "Type: Medical"
			Item.Type.MISC:
				type_text = "Type: Miscellaneous"
		
		type_label.text = type_text
		equippable_label.text = "Equippable: " + ("Yes" if item.is_equippable else "No")
	else:
		item_name_label.text = "Empty Slot"
		item_description.text = "This inventory slot is empty."
		type_label.text = ""
		equippable_label.text = ""

func update_display():
	# Update all slots
	for i in range(slots.size()):
		update_slot(i)
	
	# Update selection
	update_selection()

func _on_slot_clicked(slot_index: int):
	click_sound.play()
	selected_slot = slot_index
	update_selection()
	
	var item = get_item(slot_index)
	if item:
		item_selected.emit(item)
		if item.is_equippable:
			equip_sound.play()
			item_equipped.emit(item)
	else:
		unequip_sound.play()
		item_unequipped.emit()

func _on_slot_hovered(slot_index: int):
	# Highlight the hovered slot
	for i in range(slots.size()):
		slots[i].set_highlighted(i == slot_index) 