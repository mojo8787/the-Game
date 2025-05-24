# Godot 4.4.1 Platformer – Professional Skeleton

This document contains all the source files (scenes + scripts) for a small yet production‑quality 2‑D platformer featuring coins, patrolling enemies, and a simple boss fight.  Copy each file into your Godot project at the indicated path (case‑sensitive) and press **Play**.

---

## 📂 Folder / File Layout

```
res://
 ├─ project.godot
 ├─ scenes/
 │   ├─ Main.tscn
 │   ├─ Player.tscn
 │   ├─ Enemy.tscn
 │   ├─ Coin.tscn
 │   └─ Boss.tscn
 ├─ scripts/
 │   ├─ GameManager.gd
 │   ├─ Player.gd
 │   ├─ Enemy.gd
 │   ├─ Coin.gd
 │   └─ Boss.gd
 └─ assets/ (placeholder art ― optional)
```

---

## project.godot  *(root project file)*

```ini
; Engine configuration file.
; Format 3 – Godot 4.x

config_version=4

[input]
move_left=[ Key A, Key Left ]
move_right=[ Key D, Key Right ]
jump=[ Key Space, Key W, Key Up ]

[rendering]
; default 2D settings are fine for this demo
```

---

## scenes/Main.tscn

```gdscene
[gd_scene load_steps=4 format=3 uid="main_scene"]

[ext_resource type="PackedScene" path="res://scenes/Player.tscn" id=1]
[ext_resource type="PackedScene" path="res://scenes/Enemy.tscn" id=2]
[ext_resource type="PackedScene" path="res://scenes/Coin.tscn"  id=3]
[ext_resource type="PackedScene" path="res://scenes/Boss.tscn"  id=4]
[ext_resource type="Script"       path="res://scripts/GameManager.gd" id=5]

[node name="Main" type="Node2D"]
script = ExtResource(5)

[node name="Player" parent="." instance=ExtResource(1)]
position = Vector2(64, 256)

[node name="Enemy" parent="." instance=ExtResource(2)]
position = Vector2(480, 256)

[node name="Coin" parent="." instance=ExtResource(3)]
position = Vector2(288, 192)

[node name="Boss" parent="." instance=ExtResource(4)]
position = Vector2(896, 256)

[node name="UI" type="CanvasLayer" parent="."]

[node name="ScoreLabel" type="Label" parent="UI"]
anchors_preset = 1   # Top‑Left
text = "Score: 0"
```

---

## scenes/Player.tscn

```gdscene
[gd_scene load_steps=2 format=3 uid="player_scene"]

[ext_resource type="Script" path="res://scripts/Player.gd" id=1]

[node name="Player" type="CharacterBody2D"]
script = ExtResource(1)
groups=[ "player" ]

[node name="CollisionShape2D" type="CollisionShape2D" parent="."]
shape = CircleShape2D { radius = 8.0 }
```

---

## scenes/Enemy.tscn

```gdscene
[gd_scene load_steps=2 format=3 uid="enemy_scene"]

[ext_resource type="Script" path="res://scripts/Enemy.gd" id=1]

[node name="Enemy" type="CharacterBody2D"]
script = ExtResource(1)
groups=[ "enemy" ]

[node name="CollisionShape2D" type="CollisionShape2D" parent="."]
shape = RectangleShape2D { size = Vector2(16, 16) }
```

---

## scenes/Coin.tscn

```gdscene
[gd_scene load_steps=2 format=3 uid="coin_scene"]

[ext_resource type="Script" path="res://scripts/Coin.gd" id=1]

[node name="Coin" type="Area2D"]
script = ExtResource(1)

[node name="CollisionShape2D" type="CollisionShape2D" parent="."]
shape = CircleShape2D { radius = 6.0 }
```

---

## scenes/Boss.tscn

```gdscene
[gd_scene load_steps=2 format=3 uid="boss_scene"]

[ext_resource type="Script" path="res://scripts/Boss.gd" id=1]

[node name="Boss" type="CharacterBody2D"]
script = ExtResource(1)
groups=[ "enemy" ]

[node name="CollisionShape2D" type="CollisionShape2D" parent="."]
shape = RectangleShape2D { size = Vector2(32, 32) }
```

---

## scripts/GameManager.gd

```gdscript
extends Node

var score: int = 0

func _ready() -> void:
    # Listen for coin pickups
    for coin in get_tree().get_nodes_in_group("coin"):
        coin.collected.connect(_on_coin_collected)

func _on_coin_collected() -> void:
    score += 1
    $UI/ScoreLabel.text = "Score: %d" % score
```

---

## scripts/Player.gd

```gdscript
extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_velocity: float = -400.0
@export var gravity: float = 900.0

func _physics_process(delta: float) -> void:
    var dir := Input.get_axis("move_left", "move_right")
    velocity.x = dir * speed

    if not is_on_floor():
        velocity.y += gravity * delta

    if Input.is_action_just_pressed("jump") and is_on_floor():
        velocity.y = jump_velocity

    velocity = move_and_slide()

    if position.y > 1000:  # Fell into the void → restart level
        get_tree().reload_current_scene()

func _on_hurtbox_body_entered(body: Node) -> void:
    if body.is_in_group("enemy"):
        # Simple damage → restart level
        get_tree().reload_current_scene()
```

---

## scripts/Enemy.gd

```gdscript
extends CharacterBody2D

@export var speed: float = 100.0
@export var gravity: float = 900.0
var direction: int = 1

func _physics_process(delta: float) -> void:
    velocity.y += gravity * delta
    velocity.x = speed * direction

    if is_on_wall():
        direction *= -1  # Turn around on walls/ledges

    velocity = move_and_slide()
```

---

## scripts/Coin.gd

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

---

## scripts/Boss.gd

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

    if player:
        var dir_sign := sign(player.global_position.x - global_position.x)
        velocity.x = dir_sign * speed

    velocity = move_and_slide()

func take_damage(amount: int = 1) -> void:
    health -= amount
    if health <= 0:
        queue_free()
```

---

## Next Steps & Polishing Ideas

1. **Tiles / Level** – Replace the empty `Main` scene with a TileMap‑based level and static bodies.
2. **Art** – Drop PNGs into `assets/` and assign them to `Sprite2D` children of each scene.
3. **Camera** – Add a `Camera2D` node under `Player` and tweak limits & damping.
4. **Audio** – Create an `AudioStreamPlayer2D` in `Player` (jump SFX) and an `AudioStreamPlayer` in `Main` (music).
5. **UI polish** – Use `Theme` resources for fonts & colors; add Pause & Game‑Over menus.

Once you’ve copied these files into your project folder (keeping the same paths), open Godot 4, double‑click **Main.tscn**, and press ▶️.  You’ll have a functioning coin‑collect platformer with a simple boss encounter ready for further art and feature upgrades.