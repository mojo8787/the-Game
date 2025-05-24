extends Control

signal slot_clicked(slot_index: int)
signal slot_hovered(slot_index: int)

@export var slot_index: int = 0
var current_item: Item = null

@onready var background: TextureRect = $Background
@onready var item_icon: TextureRect = $ItemIcon
@onready var highlight_overlay: TextureRect = $HighlightOverlay
@onready var selection_glow: TextureRect = $SelectionGlow

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	gui_input.connect(_on_gui_input)
	
func set_item(item: Item):
	current_item = item
	if item:
		item_icon.texture = item.icon
		item_icon.visible = true
	else:
		item_icon.texture = null
		item_icon.visible = false

func set_selected(selected: bool):
	if selected:
		selection_glow.modulate = Color.WHITE
		var tween = create_tween()
		tween.set_loops()
		tween.tween_property(selection_glow, "modulate:a", 0.3, 0.5)
		tween.tween_property(selection_glow, "modulate:a", 0.8, 0.5)
	else:
		selection_glow.modulate = Color.TRANSPARENT

func set_highlighted(highlighted: bool):
	var tween = create_tween()
	if highlighted:
		tween.tween_property(highlight_overlay, "modulate:a", 0.5, 0.1)
	else:
		tween.tween_property(highlight_overlay, "modulate:a", 0.0, 0.1)

func _on_mouse_entered():
	slot_hovered.emit(slot_index)

func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		slot_clicked.emit(slot_index) 