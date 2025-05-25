# Animated Drone System 🚁✨

## Overview
The drone system features advanced AI behavior with multiple states, player detection, patrol patterns, and dynamic visual/audio effects. Perfect for adding surveillance and challenge elements to your platformer.

## 🤖 Drone States & Behavior

### 1. Hovering
- **Description**: Default idle state with subtle floating motion
- **Visual**: Gentle up/down bobbing with slight rotation
- **Duration**: Random intervals before choosing next action
- **Particles**: Steady thruster effects

### 2. Patrolling  
- **Description**: Follows predetermined patrol routes
- **Pattern**: Square pattern around starting position
- **Speed**: 80 units/second
- **Visual**: Faces movement direction, flying animation
- **Behavior**: Visits 4 patrol points in sequence

### 3. Scanning
- **Description**: Activated when player enters detection range
- **Visual**: Rotating cyan scan beam (180°/second)
- **Duration**: 3 seconds
- **Effect**: Pulses beam visibility for emphasis
- **Transition**: Leads to chasing if player still detected

### 4. Chasing
- **Description**: Actively pursues detected player
- **Speed**: 120 units/second (fastest mode)
- **Visual**: Increased particle intensity, faces player
- **Behavior**: Direct pursuit with enhanced thruster effects
- **Range**: Continues until player leaves detection area

### 5. Returning
- **Description**: Returns to start position when player lost
- **Speed**: 80 units/second
- **Visual**: Flying animation toward home position
- **Transition**: Back to hovering when within 30 units of start

## 🎯 Detection & AI

### Detection System
- **Range**: 80 unit radius detection area
- **Trigger**: Any physics body entering area
- **Response**: Immediate state change to scanning
- **Smart Tracking**: Remembers player reference for pursuit

### AI Decision Making
- **Random Behavior**: 60% chance patrol, 40% chance scan from hover
- **State Persistence**: Completes actions before transitioning
- **Return Logic**: Always returns home when losing target
- **Timer-Based**: Uses timers for state duration control

## 🎨 Visual Effects

### Particle Systems
- **Thruster Effects**: Continuous downward particle emission
- **Dynamic Intensity**: Scales with movement speed
- **Performance**: GPU-accelerated particles
- **Visual Feedback**: Intensity indicates drone activity level

### Scan Beam
- **Type**: Rotating Line2D with custom material
- **Color**: Cyan (0, 1, 1) with alpha pulsing
- **Animation**: 360° rotation during scanning
- **Visibility**: Only shown during scanning state

### Animation States
- **Hover**: Gentle 5 FPS idle animation
- **Flying**: 8 FPS movement animation  
- **Scanning**: 3 FPS focused scanning animation
- **Sprite Flipping**: Faces movement direction automatically

## 🔧 Customizable Parameters

All drone behavior can be tweaked via exported variables:

### Movement Settings
- **hover_speed**: 50.0 - Speed during idle drift
- **patrol_speed**: 80.0 - Normal patrol movement speed
- **chase_speed**: 120.0 - Maximum pursuit speed
- **patrol_distance**: 200.0 - Size of patrol area

### Animation Settings
- **hover_amplitude**: 15.0 - Up/down floating distance
- **hover_frequency**: 2.0 - Speed of floating motion
- **detection_range**: 80.0 - Player detection radius

## 🎵 Audio Integration

### Sound Design
- **Spatial Audio**: AudioStreamPlayer2D for positional sound
- **Pitch Variation**: Dynamic pitch during scanning
- **Volume Control**: -15dB default, customizable
- **Integration Ready**: Easy to add drone sound effects

### Audio Triggers
- **State Changes**: Audio cues for behavior transitions
- **Scanning**: Pitch variation during scan mode
- **Movement**: Could add thruster sound effects
- **Detection**: Alert sounds when player spotted

## 📁 File Organization

```
assets/characters/drone/
└── drone_base.png        # Main drone sprite

scenes/
└── Drone.tscn           # Complete animated drone scene

scripts/
└── Drone.gd             # AI behavior and animation control
```

## 🎮 Gameplay Integration

### Player Interaction
- **Detection**: Spots player in 80-unit radius
- **Pursuit**: Chases player at high speed
- **Collision**: Part of "enemy" group for player damage
- **Stealth Challenge**: Avoid detection zones

### Level Design
- **Patrol Routes**: Automatically generated around spawn point
- **Multiple Drones**: Can place multiple instances
- **Strategic Placement**: Position to create interesting challenges
- **Safe Zones**: Areas outside detection range

## 🚀 Advanced Features

### Utility Functions
```gdscript
alert_drone(position)     # Make drone investigate specific location
disable_drone()           # Disable drone (destruction effect)
```

### State Debugging
- **Console Output**: Logs state changes for debugging
- **Visual Indicators**: Scan beam shows active detection
- **Particle Feedback**: Thruster intensity shows activity

### Performance Optimizations
- **Efficient Pathfinding**: Simple but effective movement
- **Smart Updates**: Only processes necessary calculations
- **Particle Management**: Controlled particle counts
- **Timer-Based Logic**: Reduces per-frame calculations

## 🎯 Usage Examples

### Basic Security Drone
```gdscript
# Place in level for basic patrol/detection
# Default settings work great for most scenarios
```

### Alert System
```gdscript
# Make drone investigate disturbances
drone.alert_drone(noise_position)
```

### Boss Battle Minion
```gdscript
# Disable when boss defeated
drone.disable_drone()
```

## ✨ Enhancement Ideas

### Potential Upgrades
- **Multiple Sprite Frames**: Add rotor animation frames
- **Sound Effects**: Engine hum, alert beeps, scan sounds
- **Damage System**: Health points and destruction effects
- **Network Behavior**: Multiple drones coordinating
- **Environmental Interaction**: React to alarms, lights

### Animation Expansions
- **Rotor Spinning**: Separate rotor sprite animation
- **Damage States**: Visual feedback for taking damage
- **Special Abilities**: EMP blasts, searchlights
- **Weather Effects**: React to rain, wind

This drone system adds a professional level of AI challenge and visual polish to your platformer game! 🎮🚁 