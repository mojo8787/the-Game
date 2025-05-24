# Contributing to Professional 2D Platformer

Thank you for your interest in contributing to our 2D platformer game! This document provides guidelines and information for contributors.

## 🚀 Getting Started

### Prerequisites
- [Godot 4.4.1](https://godotengine.org/download/) or later
- Git for version control
- Basic knowledge of GDScript
- Understanding of 2D game development concepts

### Development Setup
1. **Fork the repository** on GitHub
2. **Clone your fork**:
   ```bash
   git clone https://github.com/YOUR_USERNAME/the-Game.git
   cd the-Game
   ```
3. **Open in Godot** and ensure everything runs properly
4. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## 🎯 How to Contribute

### Types of Contributions
- 🐛 **Bug fixes** - Fix gameplay issues or technical problems
- ✨ **New features** - Add new game mechanics or systems
- 🎨 **Assets** - Create new sprites, sounds, or visual effects
- 📚 **Documentation** - Improve guides, comments, or README
- 🔧 **Code quality** - Refactoring, optimization, or cleanup

### Priority Areas
1. **Sound System** - Adding audio effects and music
2. **Animation System** - Sprite animations for characters
3. **Level Design** - Creating new levels and challenges
4. **UI/UX** - Menus, HUD improvements, and user experience
5. **Performance** - Optimization and mobile compatibility

## 📝 Code Standards

### GDScript Guidelines
```gdscript
# Use explicit typing when possible
var health: int = 100
var speed: float = 200.0

# Use descriptive variable names
var jump_velocity: float = -400.0  # Good
var jv: float = -400.0            # Avoid

# Comment complex logic
func _physics_process(delta: float) -> void:
    # Handle horizontal movement
    var direction := Input.get_axis("move_left", "move_right")
    velocity.x = direction * speed
    
    # Apply gravity when not on ground
    if not is_on_floor():
        velocity.y += gravity * delta
```

### Scene Organization
- **Keep scenes modular** and focused on single responsibilities
- **Use consistent naming** (PascalCase for scenes, snake_case for scripts)
- **Group related nodes** for better organization
- **Add comments** in complex scene setups

### Asset Guidelines
- **Pixel art style** - Maintain consistent 16-48px sprite sizes
- **Optimized file sizes** - Use appropriate compression
- **Consistent color palette** - Match existing game aesthetics
- **Proper naming** - Use descriptive, lowercase filenames

## 🔄 Workflow

### Making Changes
1. **Create a feature branch** from main
2. **Make your changes** in small, focused commits
3. **Test thoroughly** in Godot
4. **Update documentation** if needed
5. **Submit a pull request**

### Commit Messages
Use clear, descriptive commit messages:
```
feat: Add sound effects for jumping and coin pickup
fix: Resolve enemy patrol boundary detection
docs: Update README with new features
refactor: Simplify player movement code
```

### Pull Request Process
1. **Fill out the PR template** completely
2. **Include screenshots/GIFs** for visual changes
3. **Reference related issues** if applicable
4. **Ensure all tests pass** (if we add automated testing)
5. **Respond to review feedback** promptly

## 🧪 Testing

### Manual Testing Checklist
- [ ] Game runs without errors
- [ ] All controls work properly
- [ ] Collision detection functions correctly
- [ ] Camera follows player smoothly
- [ ] Parallax effect works as expected
- [ ] Score system updates correctly
- [ ] Performance remains smooth

### Testing New Features
- **Test edge cases** - What happens at boundaries?
- **Check compatibility** - Does it work with existing systems?
- **Performance impact** - Does it maintain 60 FPS?
- **User experience** - Is it intuitive and fun?

## 🎨 Asset Creation Guidelines

### Sprite Requirements
- **Resolution**: Maintain pixel art aesthetic
- **Color palette**: Match existing game colors
- **Animation frames**: 60 FPS for smooth animation
- **Transparency**: Use proper alpha channels

### Audio Requirements
- **Format**: OGG Vorbis preferred
- **Quality**: 44.1kHz, 16-bit minimum
- **Length**: Keep sound effects under 2 seconds
- **Volume**: Consistent levels across all audio

## 🐛 Bug Reports

### Bug Report Template
```markdown
**Describe the bug**
A clear description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:
1. Go to '...'
2. Click on '....'
3. See error

**Expected behavior**
What you expected to happen.

**Screenshots**
If applicable, add screenshots.

**Environment:**
- OS: [e.g. Windows 10, macOS]
- Godot Version: [e.g. 4.4.1]
- Game Version: [e.g. commit hash]
```

## 💡 Feature Requests

### Feature Request Template
```markdown
**Is your feature request related to a problem?**
A clear description of what the problem is.

**Describe the solution**
A clear description of what you want to happen.

**Additional context**
Add any other context or screenshots about the feature.
```

## 📋 Code Review

### What We Look For
- **Code quality** - Clean, readable, well-commented
- **Performance** - Efficient algorithms and resource usage
- **Compatibility** - Works with existing systems
- **Testing** - Has been thoroughly tested
- **Documentation** - Includes necessary documentation

### Review Process
1. **Automated checks** (if available)
2. **Manual code review** by maintainers
3. **Testing verification**
4. **Documentation review**
5. **Final approval and merge**

## 🏆 Recognition

Contributors will be:
- **Listed in the README** acknowledgments section
- **Credited in-game** for significant contributions
- **Invited to the contributors team** for ongoing contributors

## 📞 Getting Help

### Where to Ask Questions
- **GitHub Issues** - For bug reports and feature requests
- **GitHub Discussions** - For general questions and ideas
- **Discord** - Real-time chat with the community (if available)

### Useful Resources
- [Godot Documentation](https://docs.godotengine.org/)
- [GDScript Style Guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html)
- [Pixel Art Tutorials](https://blog.studiominiboss.com/pixelart)

## 📄 License

By contributing, you agree that your contributions will be licensed under the same license as the project (MIT License).

---

Thank you for contributing to our game! Every contribution, no matter how small, helps make the project better. 🎮✨ 