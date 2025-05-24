# Development Guide

This document provides detailed information for developers working on the Professional 2D Platformer game.

## 🏗️ Architecture Overview

### Project Structure
```
Game/
├── project.godot           # Project configuration
├── scenes/                 # All game scenes
├── scripts/               # GDScript files
├── assets/                # Art, audio, and resources
└── docs/                  # Documentation
```

### Scene Architecture
- **Main.tscn**: Root scene containing the level and parallax system
- **Player.tscn**: Player character with movement and camera
- **Enemy.tscn**: Basic patrol enemy
- **Boss.tscn**: Advanced enemy with AI
- **Coin.tscn**: Collectible item

## 🎮 Core Systems

### Player Controller (`Player.gd`)
```gdscript
extends CharacterBody2D

# Movement parameters
@export var speed: float = 200.0
@export var jump_velocity: float = -400.0
@export var gravity: float = 900.0

func _physics_process(delta: float) -> void:
    # Horizontal movement
    var dir := Input.get_axis("move_left", "move_right")
    velocity.x = dir * speed
    
    # Gravity application
    if not is_on_floor():
        velocity.y += gravity * delta
    
    # Jump mechanics
    if Input.is_action_just_pressed("jump") and is_on_floor():
        velocity.y = jump_velocity
    
    # Apply movement
    move_and_slide()
    
    # Fall detection
    if position.y > 1000:
        get_tree().reload_current_scene()
```

### Enemy AI (`Enemy.gd`)
```gdscript
extends CharacterBody2D

@export var speed: float = 100.0
@export var gravity: float = 900.0
var direction: int = 1

func _physics_process(delta: float) -> void:
    # Apply gravity
    velocity.y += gravity * delta
    
    # Horizontal patrol movement
    velocity.x = speed * direction
    
    # Turn around at walls/edges
    if is_on_wall():
        direction *= -1
    
    move_and_slide()
```

### Boss AI (`Boss.gd`)
```gdscript
extends CharacterBody2D

@export var health: int = 10
@export var speed: float = 80.0
@export var gravity: float = 900.0

var player: CharacterBody2D

func _ready() -> void:
    player = get_tree().get_first_node_in_group("player") as CharacterBody2D

func _physics_process(delta: float) -> void:
    velocity.y += gravity * delta
    
    # Track player position
    if player:
        var dir_sign: float = sign(player.global_position.x - global_position.x)
        velocity.x = dir_sign * speed
    
    move_and_slide()
```

### Coin Collection (`Coin.gd`)
```gdscript
extends Area2D

signal collected

func _ready() -> void:
    body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
    if body.is_in_group("player"):
        emit_signal("collected")
        queue_free()
```

### Game Management (`GameManager.gd`)
```gdscript
extends Node

var score: int = 0

func _ready() -> void:
    # Connect to all coin signals
    for coin in get_tree().get_nodes_in_group("coin"):
        coin.collected.connect(_on_coin_collected)

func _on_coin_collected() -> void:
    score += 1
    $UI/ScoreLabel.text = "Score: %d" % score
```

## 🎨 Parallax System

### Layer Configuration
The parallax system uses 5 layers with different motion scales:

```gdscript
# Layer motion scales (percentage of camera movement)
Sky Layer:        5%  (0.05)  # Furthest background
Mountain Layer:   8%  (0.08)  # Distant mountains
Forest Layer:     30% (0.3)   # Middle distance trees
Foggy Forest:     50% (0.5)   # Closer atmospheric layer
Greenery:         70% (0.7)   # Foreground vegetation
```

### Adding New Parallax Layers
1. Create a new `ParallaxLayer` node under `ParallaxBackground`
2. Add a `Sprite2D` child with your texture
3. Set appropriate `motion_scale` values
4. Configure `motion_mirroring` for seamless looping

## 🔧 Camera System

### Camera Configuration
```gdscript
# Camera settings in Player.tscn
zoom = Vector2(2, 2)              # 2x zoom for closer view
position_smoothing_enabled = true  # Smooth camera movement
position_smoothing_speed = 3.0     # Smoothing responsiveness

# Camera boundaries
limit_left = -200
limit_top = -100
limit_right = 1400
limit_bottom = 500
```

## 🎯 Input System

### Input Map Configuration
```ini
# project.godot input configuration
[input]
move_left={
    "deadzone": 0.5,
    "events": [A key, Left Arrow]
}
move_right={
    "deadzone": 0.5,
    "events": [D key, Right Arrow]
}
jump={
    "deadzone": 0.5,
    "events": [Space, W key, Up Arrow]
}
```

## 🎨 Asset Pipeline

### Asset Optimization
All assets are automatically resized using macOS `sips` tool:

```bash
# Character sprites
sips -z 32 32 player.png      # Player: 32x32
sips -z 24 24 enemy.png       # Enemy: 24x24
sips -z 48 48 boss.png        # Boss: 48x48
sips -z 16 16 coin.png        # Coin: 16x16

# Environment assets
sips -z 600 1024 background.png  # Backgrounds: 1024x600
sips -z 32 32 ground_tile.png    # Ground: 32x32
sips -z 16 64 platform.png       # Platforms: 64x16
```

### Asset Naming Conventions
- **Characters**: `[character_name].png`
- **Environment**: `[element]_[variant].png`
- **Backgrounds**: `[theme]_[number].png`
- **Effects**: `[effect_type]_[state].png`

## 🏃‍♂️ Performance Optimization

### Collision Shapes
- Use `CircleShape2D` for circular objects (player, coins)
- Use `RectangleShape2D` for rectangular objects (enemies, platforms)
- Keep collision shapes simple for better performance

### Texture Settings
```ini
# project.godot rendering settings
[rendering]
textures/canvas_textures/default_texture_filter=0  # Pixel-perfect rendering
```

### Memory Management
- Use `queue_free()` instead of direct deletion
- Minimize use of `get_tree()` calls in `_process()` functions
- Cache frequently accessed nodes in `_ready()`

## 🧪 Testing Guidelines

### Unit Testing Checklist
- [ ] Player movement in all directions
- [ ] Jump mechanics and landing detection
- [ ] Enemy patrol behavior and wall collision
- [ ] Boss tracking and movement
- [ ] Coin collection and score updates
- [ ] Camera following and boundaries
- [ ] Parallax scrolling at different speeds
- [ ] Level restart conditions

### Performance Testing
- Monitor FPS during gameplay
- Test with multiple enemies and coins
- Verify smooth parallax scrolling
- Check memory usage over time

## 🔍 Debugging

### Common Issues
1. **Player falling through platforms**: Check collision layers and masks
2. **Camera not following**: Ensure Camera2D is child of Player
3. **Parallax not working**: Verify ParallaxBackground structure
4. **Input not responding**: Check Input Map configuration

### Debug Tools
```gdscript
# Enable debug collision shapes
func _ready():
    get_tree().debug_collisions_hint = true

# Print debug information
func _physics_process(delta):
    print("Player position: ", global_position)
    print("Velocity: ", velocity)
    print("On floor: ", is_on_floor())
```

## 🚀 Build and Export

### Export Settings
1. Create export templates for target platforms
2. Configure export settings in Project > Export
3. Test exported builds on target devices
4. Optimize for different screen resolutions

### Platform-Specific Notes
- **Windows**: Include .exe and .pck files
- **macOS**: Create .dmg installer
- **Linux**: Provide AppImage or .deb package
- **Web**: Export to HTML5 for browser play

## 📚 Resources

### Godot Documentation
- [CharacterBody2D](https://docs.godotengine.org/en/stable/classes/class_characterbody2d.html)
- [ParallaxBackground](https://docs.godotengine.org/en/stable/classes/class_parallaxbackground.html)
- [Input Handling](https://docs.godotengine.org/en/stable/tutorials/inputs/index.html)

### Community Resources
- [Godot Discord](https://discord.gg/godotengine)
- [r/godot](https://www.reddit.com/r/godot/)
- [Godot Asset Library](https://godotengine.org/asset-library/asset)

---

This development guide is continuously updated as the project evolves. For questions or clarifications, please open an issue on GitHub. 