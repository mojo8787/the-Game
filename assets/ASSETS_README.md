# Game Assets Organization

This document describes the organization and naming convention for all game assets.

## Directory Structure

```
assets/
├── items/
│   ├── weapons/        # Weapon icons and sprites
│   ├── armor/          # Armor and protective gear
│   ├── medical/        # Health and medical items
│   └── misc/           # Miscellaneous items (keycards, etc.)
├── ui/                 # User interface elements
├── backgrounds/        # Background images and parallax layers
├── grounds/           # Ground tiles and platforms
├── platforms/         # Platform sprites
├── trees/             # Tree and vegetation sprites
└── backup/            # Backup assets

## Asset Categories

### Weapons (`assets/items/weapons/`)
- `pistol_icon_1.png` - Primary pistol icon variant
- `pistol_icon_2.png` - Alternative pistol icon variant
- `rifle_icon_1.png` - Primary rifle icon variant
- `rifle_icon_2.png` - Alternative rifle icon variant
- `grenade_1.png` - Primary grenade sprite
- `grenade_2.png` - Alternative grenade sprite

### Armor (`assets/items/armor/`)
- `tactical_helmet.png` - Tactical helmet icon
- `kevlar_vest_1.png` - Primary kevlar vest variant
- `kevlar_vest_2.png` - Alternative kevlar vest variant
- `combat_boots_1.png` - Primary combat boots variant
- `combat_boots_2.png` - Alternative combat boots variant

### Medical Items (`assets/items/medical/`)
- `medical_kit_1.png` - Standard medical kit icon
- `medical_kit_2.png` - Alternative medical kit icon
- `medical_kit_blinking_1.png` - Animated medical kit (frame 1)
- `medical_kit_blinking_2.png` - Animated medical kit (frame 2)

### Miscellaneous Items (`assets/items/misc/`)
- `electronic_keycard_1.png` - Primary electronic keycard
- `electronic_keycard_2.png` - Alternative electronic keycard

### UI Elements (`assets/ui/`)
- `inventory_slot_1.png` - Primary inventory slot design
- `inventory_slot_2.png` - Alternative inventory slot design
- `inventory_highlight_1.png` - Primary selection highlight
- `inventory_highlight_2.png` - Alternative selection highlight
- `teal_glow_animation.png` - Teal glow effect frame

## Audio Assets
- `jump.wav` - Player jump sound effect
- `coin_pickup.wav` - Coin collection sound effect
- `enemy_hit.wav` - Enemy collision sound effect

## Existing Game Assets
- `player.png` - Player character sprite
- `enemy.png` - Enemy character sprite
- `boss.png` - Boss character sprite
- `coin.png` - Collectible coin sprite
- `background.png` - Main background image
- `platform.png` - Platform sprite
- `ground_tile.png` - Ground tile sprite

## Naming Convention

All assets follow a consistent naming pattern:
- Use lowercase letters and underscores
- Include variant numbers for multiple versions (e.g., `_1`, `_2`)
- Use descriptive names that indicate the asset's purpose
- Group related assets in appropriate subdirectories

## Usage Notes

- All new assets are high-resolution PNG files (approximately 2MB each)
- Multiple variants are provided for most items to allow for variety
- Blinking medical kit assets can be used for animation sequences
- UI elements are designed to work together for a cohesive interface
- All assets maintain pixel art style consistent with the game's aesthetic 