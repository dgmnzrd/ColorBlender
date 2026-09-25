# Color Blender

Color Blender is a native macOS utility for generating color palettes
between two endpoint colors.

It is implemented in Objective-C using AppKit and is designed to behave
like a native macOS application while preserving the core workflow of
the original Color Blender tool.

The project is developed in Visual Studio Code and built directly from
the command line using Make and Apple Clang. It does not use or require
an Xcode project or workspace.

## Version

**1.0.0**

---

## Features

Color Blender 1.0.0 includes:

- HEX color input
- RGB color input
- RGB percentage input
- Two endpoint colors
- 1–10 midpoint colors
- RGB color interpolation
- Generated palettes of up to 12 colors
- Classic web-safe color picker
- Blend and Clear actions
- Automatic Light Mode and Dark Mode
- Native macOS controls and behaviors
- Keyboard-compatible controls
- Invalid-input handling

---

## How it works

Choose two endpoint colors:

    Color 1: #5B21B6
    Color 2: #FF5B00

Select the desired number of midpoint colors and press **Blend Colors**.

Color Blender interpolates between both endpoint colors in RGB space
and generates the resulting palette in order.

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

Changing the selected format changes the textual representation of
valid colors without changing their underlying color values.

---

## Midpoints

Color Blender supports between **1 and 10 midpoint colors**.

A generated palette contains:

    Color 1
    +
    1–10 midpoint colors
    +
    Color 2

The maximum palette size is therefore **12 colors**.

---

## Web-safe colors

Color Blender includes the classic web-safe color grid.

Web-safe colors are generated from RGB combinations of:

    00
    33
    66
    99
    CC
    FF

A selected web-safe color can be applied to the active color input.

---

## Native macOS interface

Color Blender uses AppKit and native macOS behaviors.

The application supports:

- Light Mode
- Dark Mode
- System accent colors
- Retina rendering
- Keyboard focus
- Native window resizing
- Standard macOS window behavior

The application follows the system appearance automatically and does
not force a specific Light or Dark appearance.

---

## Development environment

Color Blender is developed using **Visual Studio Code**.

The project intentionally does not use:

- `.xcodeproj`
- `.xcworkspace`
- Xcode schemes
- Xcode-specific build configuration

Compilation is handled directly by the included `Makefile`.

Xcode is not part of the development or build workflow.

---

## Requirements

To build Color Blender you need:

- macOS
- Apple Clang
- macOS SDK
- `make`

These development tools may be provided by Apple's Command Line Tools.

---

## Building

Build the application:

    make

The resulting application bundle is created at:

    build/ColorBlender.app

Build and launch the application:

    make run

Remove generated build files:

    make clean

Perform a clean rebuild:

    make rebuild

---

## Project structure

The source code is organized by responsibility:

    ColorBlender/
    ├── App/
    ├── Controllers/
    ├── Models/
    ├── Services/
    └── Views/

    Tests/

    Makefile
    README.md
    DESIGN.md
    CLAUDE.md

### App

Contains the application lifecycle.

This includes application startup, window creation and other
application-level responsibilities.

Visual layout and color-processing logic do not belong here.

### Controllers

Coordinates application interaction.

`MainViewController` acts as the main coordinator between the
application views and color-processing services.

### Models

Contains color representation and conversion logic.

`CBColor` represents colors independently from the interface and
supports parsing and serialization of the supported color formats.

### Services

Contains reusable application logic.

`ColorBlenderEngine` performs RGB interpolation independently from the
user interface.

### Views

Contains native AppKit interface components.

This includes:

- `ColorInputView`
- `PaletteView`
- `WebSafeColorPickerView`

Views are responsible for presentation and user interaction, not color
interpolation or application lifecycle behavior.

---

## Architecture

The application follows a simple separation of responsibilities:

    App
     │
     ▼
    Controllers
     │
     ├──────────────► Views
     │
     ▼
    Services
     │
     ▼
    Models

Views communicate user interaction back to the main controller using
delegate protocols.

`MainViewController` remains the central coordination point instead of
using shared mutable application state.

---

## Tests

Test source files are stored under:

    Tests/

The test infrastructure is independent from the normal application
build.

The standard application build is performed through:

    make

Tests should only be considered part of the automated development
workflow when they can be executed directly from the command line
without requiring an Xcode project or workspace.

---

## Design

Application design and interface conventions are documented in:

    DESIGN.md

The design system defines:

- native macOS appearance
- semantic system colors
- typography
- layout
- native controls
- color input behavior
- palette presentation
- web-safe color picker behavior
- accessibility
- application architecture

---

## Versioning

Color Blender follows Semantic Versioning:

    MAJOR.MINOR.PATCH

For example:

    1.0.0

### MAJOR

Incremented when incompatible changes are introduced.

### MINOR

Incremented when backward-compatible functionality is added.

### PATCH

Incremented for backward-compatible bug fixes, maintenance changes,
or corrections that do not introduce new functionality or break
existing behavior.

---

## Version 1.0.0

Version 1.0.0 establishes the first stable release of the native
Color Blender application.

The release reproduces the core Color Blender workflow using a native
Objective-C and AppKit implementation.

The 1.0.0 release establishes the baseline for future development.

New color spaces, additional interpolation algorithms, export options
and advanced palette tools are outside the scope of version 1.0.0.