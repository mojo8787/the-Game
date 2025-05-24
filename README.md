# 🎮 Professional 2D Platformer Game

A beautiful, fully-featured 2D platformer built with **Godot 4.4.1** featuring advanced parallax backgrounds, pixel art assets, and smooth gameplay mechanics.

![Game Screenshot](docs/screenshot.png)

## ✨ Features

### 🎯 Core Gameplay
- **Smooth character movement** with WASD/Arrow key controls
- **Responsive jumping mechanics** with proper physics
- **Coin collection system** with real-time score tracking
- **Enemy AI** with patrol behavior and collision detection
- **Boss enemy** that intelligently tracks the player
- **Level restart** on falling or enemy contact

### 🎨 Visual Excellence
- **5-layer parallax background** system for incredible depth
- **Professional pixel art assets** (custom created and optimized)
- **Smooth camera following** with proper zoom and boundaries
- **Atmospheric lighting effects** with layered transparency
- **Crisp pixel art rendering** with proper texture filtering

### 🎵 Game Elements
- **Multiple collectible coins** across different platform levels
- **Wooden platform obstacles** for jumping challenges
- **Extended level design** with proper ground and platform placement
- **Dynamic enemy spawning** and behavior systems

## 🛠️ Technical Specifications

- **Engine**: Godot 4.4.1
- **Platform**: Cross-platform (Windows, macOS, Linux)
- **Resolution**: 1024x600 (scales properly to fullscreen)
- **Art Style**: Pixel art with 16-48px sprites
- **Physics**: CharacterBody2D with move_and_slide()

## 📂 Project Structure

```
Game/
├── project.godot              # Main project configuration
├── scenes/                    # Game scene files
│   ├── Main.tscn             # Main game scene with parallax
│   ├── Player.tscn           # Player character with camera
│   ├── Enemy.tscn            # Patrol enemy
│   ├── Coin.tscn             # Collectible coin
│   └── Boss.tscn             # Boss enemy
├── scripts/                  # GDScript game logic
│   ├── GameManager.gd        # Score and game state management
│   ├── Player.gd             # Player movement and controls
│   ├── Enemy.gd              # Enemy AI and patrol behavior
│   ├── Coin.gd               # Coin collection logic
│   └── Boss.gd               # Boss AI and tracking
├── assets/                   # Game art and resources
│   ├── player.png            # Player sprite (32x32)
│   ├── enemy.png             # Enemy sprite (24x24)
│   ├── boss.png              # Boss sprite (48x48)
│   ├── coin.png              # Coin sprite (16x16)
│   ├── ground_tile.png       # Ground texture (32x32)
│   ├── platform.png          # Platform texture (64x16)
│   ├── wooden_platform_1.png # New wooden platform
│   ├── new_ground_1.png      # Enhanced ground texture
│   ├── sky_1.png             # Sky background (1024x600)
│   ├── mountains_1.png       # Mountain layer
│   ├── forest_1.png          # Forest layer
│   ├── foggy_forest_1.png    # Foggy forest layer
│   ├── greenery_1.png        # Foreground vegetation
│   └── backup/               # Original asset backups
└── docs/                     # Documentation and screenshots
```

## 🚀 Installation & Setup

### Prerequisites
- [Godot 4.4.1](https://godotengine.org/download/) or later
- Git (for cloning the repository)

### Quick Start
1. **Clone the repository**:
   ```bash
   git clone https://github.com/mojo8787/the-Game.git
   cd the-Game
   ```

2. **Open in Godot**:
   - Launch Godot 4.4.1
   - Click "Import" and select the `project.godot` file
   - Click "Import & Edit"

3. **Play the game**:
   - Press F5 or click the Play button ▶️
   - Select `Main.tscn` as the main scene
   - Enjoy!

### Command Line Play
```bash
# Navigate to project directory
cd path/to/Game

# Run directly with Godot
godot --main-pack . --main-scene "res://scenes/Main.tscn"
```

## 🎮 How to Play

### Controls
- **A/D or ←/→**: Move left and right
- **Space/W/↑**: Jump
- **F11**: Toggle fullscreen

### Objectives
- **Collect coins** by jumping to platforms
- **Avoid red enemies** that patrol the ground
- **Escape the purple boss** that chases you
- **Survive as long as possible** and get the highest score!

## 🎨 Asset Details

### Character Sprites
- **Player**: 32x32px blue character
- **Enemy**: 24x24px red patrol enemy  
- **Boss**: 48x48px purple boss enemy
- **Coin**: 16x16px golden collectible

### Environment Art
- **5-layer parallax system** with proper depth sorting
- **Optimized textures** for smooth performance
- **Consistent pixel art style** throughout

### Performance Optimizations
- **Efficient collision shapes** (CircleShape2D, RectangleShape2D)
- **Optimized sprite sizes** for memory efficiency
- **Proper texture filtering** for crisp pixel art

## 🔧 Development Features

### Advanced Systems
- **Parallax Background Manager** with 5 depth layers
- **Camera System** with smooth following and zoom
- **Physics Integration** with proper CharacterBody2D usage
- **Signal-based Architecture** for clean component communication
- **Modular Scene Design** for easy expansion

### Code Quality
- **Clean GDScript** with proper typing
- **Modular architecture** for maintainability
- **Consistent naming conventions**
- **Well-documented code structure**

## 🎯 Game Mechanics Deep Dive

### Player Controller
```gdscript
# Smooth movement with Input.get_axis()
var dir := Input.get_axis("move_left", "move_right")
velocity.x = dir * speed

# Gravity and jumping physics
if not is_on_floor():
    velocity.y += gravity * delta
if Input.is_action_just_pressed("jump") and is_on_floor():
    velocity.y = jump_velocity
```

### Parallax System
- **Sky Layer**: 5% motion scale (distant)
- **Mountain Layer**: 8% motion scale (far background)
- **Forest Layer**: 30% motion scale (middle distance)
- **Foggy Forest Layer**: 50% motion scale (closer)
- **Greenery Layer**: 70% motion scale (foreground)

## 🌟 Screenshots

### Gameplay
![Gameplay Screenshot](docs/gameplay.png)

### Parallax Effect
![Parallax Effect](docs/parallax-demo.gif)

## 🚧 Future Enhancements

### Planned Features
- [ ] **Sound Effects** (jump, coin pickup, enemy hit)
- [ ] **Background Music** with atmospheric tracks
- [ ] **Animated Sprites** for characters
- [ ] **Multiple Levels** with different themes
- [ ] **Power-ups** and special abilities
- [ ] **Particle Effects** for enhanced visual feedback
- [ ] **Save System** for high scores
- [ ] **Menu System** with settings and options

### Technical Improvements
- [ ] **Mobile Controls** for touch devices
- [ ] **Gamepad Support** for controllers
- [ ] **Advanced Enemy AI** with different behaviors
- [ ] **Procedural Level Generation**
- [ ] **Achievement System**

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Setup
1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes
4. Test thoroughly in Godot
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Godot Engine** for the amazing open-source game engine
- **Pixel Art Community** for inspiration and techniques
- **Game Development Community** for valuable feedback

## 📞 Contact

- **GitHub**: [@mojo8787](https://github.com/mojo8787)
- **Repository**: [the-Game](https://github.com/mojo8787/the-Game.git)

---

**Built with ❤️ using Godot 4.4.1** 