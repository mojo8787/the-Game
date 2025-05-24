extends Node

# Item database for easy item creation
var items_data = {
	"pistol": {
		"name": "Combat Pistol",
		"description": "A reliable sidearm for close quarters combat. Standard issue for security personnel.",
		"icon_path": "res://assets/items/weapons/pistol_icon_1.png",
		"type": Item.Type.WEAPON,
		"is_equippable": true
	},
	"rifle": {
		"name": "Assault Rifle",
		"description": "High-powered automatic weapon. Effective at medium to long range engagements.",
		"icon_path": "res://assets/items/weapons/rifle_icon_1.png", 
		"type": Item.Type.WEAPON,
		"is_equippable": true
	},
	"grenade": {
		"name": "Frag Grenade",
		"description": "Explosive device for area denial. Handle with extreme caution.",
		"icon_path": "res://assets/items/weapons/grenade_1.png",
		"type": Item.Type.WEAPON,
		"is_equippable": false
	},
	"tactical_helmet": {
		"name": "Tactical Helmet",
		"description": "Military-grade head protection with built-in communication systems.",
		"icon_path": "res://assets/items/armor/tactical_helmet.png",
		"type": Item.Type.ARMOR,
		"is_equippable": true
	},
	"kevlar_vest": {
		"name": "Kevlar Vest",
		"description": "Bulletproof vest providing excellent torso protection against projectiles.",
		"icon_path": "res://assets/items/armor/kevlar_vest_1.png",
		"type": Item.Type.ARMOR,
		"is_equippable": true
	},
	"combat_boots": {
		"name": "Combat Boots",
		"description": "Durable military footwear. Provides protection and improved mobility.",
		"icon_path": "res://assets/items/armor/combat_boots_1.png",
		"type": Item.Type.ARMOR,
		"is_equippable": true
	},
	"medical_kit": {
		"name": "Medical Kit",
		"description": "Emergency medical supplies. Can restore health when used properly.",
		"icon_path": "res://assets/items/medical/medical_kit_1.png",
		"type": Item.Type.MEDICAL,
		"is_equippable": false
	},
	"keycard": {
		"name": "Electronic Keycard",
		"description": "High-security access card. Required to unlock restricted areas.",
		"icon_path": "res://assets/items/misc/electronic_keycard_1.png",
		"type": Item.Type.MISC,
		"is_equippable": false
	}
}

func create_item(item_id: String) -> Item:
	if not items_data.has(item_id):
		print("Error: Item ID '", item_id, "' not found in database")
		return null
		
	var data = items_data[item_id]
	var item = Item.new()
	
	item.name = data.name
	item.description = data.description
	item.icon = load(data.icon_path)
	item.type = data.type
	item.is_equippable = data.is_equippable
	
	return item

func get_all_item_ids() -> Array[String]:
	var ids: Array[String] = []
	for key in items_data.keys():
		ids.append(key)
	return ids

func get_random_item() -> Item:
	var ids = get_all_item_ids()
	var random_id = ids[randi() % ids.size()]
	return create_item(random_id) 