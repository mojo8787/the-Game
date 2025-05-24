class_name Item
extends Resource

enum Type {
	WEAPON,
	ARMOR,
	MEDICAL,
	MISC
}

@export var name: String
@export var description: String
@export var icon: Texture2D
@export var type: Type
@export var is_equippable: bool = false
@export var stack_size: int = 1

func _init(item_name: String = "", item_description: String = "", item_icon: Texture2D = null, item_type: Type = Type.MISC):
	name = item_name
	description = item_description
	icon = item_icon
	type = item_type 