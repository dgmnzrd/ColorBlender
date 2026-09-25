# Color Blender

Color Blender is a native macOS utility for generating color palettes
between two colors.

It is a modern native macOS implementation inspired by the original
Color Blender tool, preserving its core color blending workflow while
using AppKit and current macOS interface conventions.

## Version

**1.0.0**

---

## Features

Color Blender 1.0.0 supports:

- HEX color input
- RGB color input
- RGB percentage input
- Two endpoint colors
- 1–10 midpoint colors
- RGB color interpolation
- Generated palettes of up to 12 colors
- Web-safe color picker
- Blend and Clear actions
- Automatic Light Mode and Dark Mode
- Native macOS controls and behaviors

---

## How it works

Choose two colors:

    Color 1: #5B21B6
    Color 2: #FF5B00

Select the number of midpoint colors and press **Blend Colors**.

Color Blender interpolates between both endpoint colors and generates
the resulting palette in order.

For example:

    #5B21B6
    #7A2B92
    #993568
    #B83F3E
    #D74A1A
    #FF5B00

The exact number of generated colors depends on the selected midpoint
count.

---

## Supported color formats

### HEX

    #5B21B6

### RGB

    rgb(91,33,182)

### RGB%

    rgb(36%,13%,71%)

Changing the selected format changes the textual representation of the
colors without changing the underlying color values.

---

## Midpoints

Color Blender supports between **1 and 10 midpoint colors**.

The generated palette therefore contains:

    Color 1
    +
    1–10 midpoint colors
    +
    Color 2

The maximum palette size is **12 colors**.

---

## Web-safe colors

Color Blender includes the classic web-safe color grid.

Web-safe colors are generated from combinations of:

    00
    33
    66
    99
    CC
    FF

A selected web-safe color can be applied directly to the active color
input.

---

## Native macOS interface

Color Blender is designed as a native macOS application.

The interface uses AppKit and follows the current system appearance
automatically.

Supported system behaviors include:

- Light Mode
- Dark Mode
- System accent colors
- Retina rendering
- Keyboard focus
- Native window resizing
- Native macOS controls

The application does not force a specific appearance.

---

## Requirements

- macOS 27 or later
- Xcode with macOS 27 SDK support

---

## Technology

Color Blender is implemented using:

- Objective-C
- AppKit
- Auto Layout

No web UI framework is used.

---

## Project structure

The source code is organized by responsibility:

    App/
        Application lifecycle

    Controllers/
        Application interaction and coordination

    Models/
        Color representation

    Services/
        Color parsing and interpolation

    Views/
        Native AppKit interface components

This keeps interface code separate from color processing and
application lifecycle responsibilities.

---

## Main components

### MainViewController

Coordinates the main Color Blender interface and user interactions.

### ColorInputView

Displays and edits an individual color input.

### PaletteView

Displays the generated color palette and textual color values.

### WebSafeColorPickerView

Provides the classic web-safe color selection grid.

### ColorBlenderEngine

Handles color interpolation and palette generation.

### CBColor

Represents color data independently from the interface.

---

## Building

1. Open the Color Blender Xcode project.
2. Select the Color Blender macOS target.
3. Choose a compatible Mac destination.
4. Build and run the application using Xcode.

Default shortcut:

    Command + R

---

## Design

Interface and design decisions are documented in:

    DESIGN.md

The design system defines:

- native macOS appearance
- semantic system colors
- typography
- layout
- controls
- color inputs
- palette presentation
- web-safe color picker behavior
- accessibility
- application architecture

---

## Versioning

Color Blender follows Semantic Versioning.

Version numbers use:

    MAJOR.MINOR.PATCH

For example:

    1.0.0

### MAJOR

Incremented for incompatible or breaking changes.

### MINOR

Incremented when backward-compatible functionality is added.

### PATCH

Incremented for backward-compatible bug fixes.

---

## Version 1.0.0

Version 1.0.0 establishes the first stable release of the native
Color Blender application.

The release reproduces the core functionality of the original Color
Blender while providing a native macOS interface and modern system
behavior.

Future releases may introduce additional color spaces, algorithms,
export options and palette tools without changing the goals of the
1.0.0 release.