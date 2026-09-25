# CLAUDE.md

This file provides guidance to Claude Code when working with code in this repository.

## What this is

Color Blender is a native macOS utility written in Objective-C using AppKit.

It generates RGB-interpolated color palettes between two endpoint colors and supports:

- HEX
- RGB
- RGB%
- 1–10 midpoint colors
- palettes of up to 12 colors
- classic web-safe color selection
- automatic Light/Dark Mode
- native macOS controls and behaviors

Color Blender is a native desktop application. It does not use a web UI framework.

Version 1.0.0 establishes the baseline behavior and design of the application.

---

## Development environment

Color Blender is developed using **Visual Studio Code**.

The repository intentionally does not use or require:

- `.xcodeproj`
- `.xcworkspace`
- Xcode schemes
- Interface Builder
- Storyboards
- XIB files
- Xcode-specific build configuration

Do not introduce an Xcode project, workspace, scheme, Storyboard, XIB, or other
Xcode-specific project structure unless the user explicitly changes this architectural
decision in the future.

The application interface is implemented programmatically using Objective-C and AppKit.

The repository must remain buildable from the command line.

---

## Build & run

The build is driven by the repository `Makefile`.

The Makefile invokes Apple Clang directly against the Objective-C sources under
`ColorBlender/` and produces the macOS application bundle.

Use:

```sh
make
```

to build:

```text
build/ColorBlender.app
```

Build and launch the application:

```sh
make run
```

Remove generated build artifacts:

```sh
make clean
```

Perform a clean rebuild:

```sh
make rebuild
```

Do not assume Xcode is available or part of the development workflow.

When modifying source code, verify that the project still builds successfully using
the Makefile.

---

## Tests

Test source files live under:

```text
Tests/
```

The repository currently contains:

```text
Tests/ColorBlenderEngineTests.m
```

The current Makefile does not provide a `test` target and does not execute this test
automatically.

Do not claim that tests pass merely because `make` succeeds.

Do not introduce an Xcode project or Xcode test bundle just to run the tests.

If test infrastructure is added, it should preserve the command-line-first development
model and ideally expose a command such as:

```sh
make test
```

Testing should remain executable from the terminal and should not require an IDE-specific
project format.

Until such infrastructure exists, distinguish clearly between:

- successful application compilation
- manual application verification
- automated test execution

These are not equivalent.

---

## Repository structure

The primary repository structure is:

```text
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
.gitignore
```

Do not create directories or architectural layers without a concrete need.

Do not add an `Assets/` directory merely because one is conventional in macOS projects.
Resources should only be added when the application actually requires them.

---

## Architecture

Source code is organized by responsibility under `ColorBlender/`.

The separation defined in `DESIGN.md` is an architectural constraint.

### App/

Application lifecycle responsibilities.

Includes:

- `main.m`
- `AppDelegate`

`AppDelegate` may handle application-level concerns such as:

- application startup
- window creation
- main menu construction

Do not place view layout, color parsing, or interpolation logic in `AppDelegate`.

### Controllers/

Application interaction and coordination.

`MainViewController` is the main coordinator.

It:

- owns and coordinates the main subviews
- responds to user actions
- acts as delegate where appropriate
- coordinates Blend and Clear behavior
- connects views with the model/service layer

It must not implement low-level RGB interpolation mathematics.

### Models/

Color representation and conversion.

`CBColor` represents application color data independently from presentation concerns.

It is responsible for supported color representations such as:

- HEX
- RGB
- RGB%

The supported format is represented by `CBColorFormat`.

`CBColor` may expose an `NSColor` representation when needed for rendering, but AppKit
presentation concerns should not leak unnecessarily into color-processing logic.

### Services/

Reusable application logic.

`ColorBlenderEngine` performs RGB interpolation.

The main interpolation API is:

```objc
+blendFromColor:toColor:midpoints:
```

Interpolation must remain independent from UI layout and application lifecycle code.

### Views/

Native AppKit presentation and interaction.

Primary views include:

- `ColorInputView`
- `PaletteView`
- `WebSafeColorPickerView`

Views may display data and report user interaction.

Views must not perform color interpolation or application lifecycle work.

---

## Communication between components

Views communicate user interaction upward to `MainViewController` using delegate
protocols where appropriate.

Current delegate relationships include:

```text
ColorInputView
       │
       ▼
ColorInputViewDelegate
       │
       ▼
MainViewController
```

and:

```text
WebSafeColorPickerView
       │
       ▼
WebSafeColorPickerViewDelegate
       │
       ▼
MainViewController
```

`MainViewController` is the central coordination point.

Do not introduce shared mutable global application state to bypass these relationships.

---

## Design constraints

See `DESIGN.md` for the complete design specification.

The following rules are architectural and visual constraints, not optional suggestions.

### Native AppKit

Prefer native AppKit controls, including:

- `NSTextField`
- `NSButton`
- `NSSegmentedControl`
- `NSStepper`
- `NSScrollView`
- `NSStackView`
- `NSColorPanel` when appropriate

Do not recreate standard macOS controls manually without a concrete reason.

### Semantic UI colors

Never hardcode ordinary interface colors.

Use semantic `NSColor` values such as:

```objc
NSColor.labelColor
NSColor.secondaryLabelColor
NSColor.windowBackgroundColor
NSColor.controlBackgroundColor
NSColor.separatorColor
NSColor.controlAccentColor
```

Literal colors are allowed when they represent actual Color Blender data, including:

- user-selected colors
- generated palette colors
- web-safe colors

Computed black or white may also be used when required as a contrast color for content
displayed over arbitrary literal color data.

Never modify actual color data to accommodate Light or Dark Mode.

### Light/Dark Mode

The application follows the system appearance automatically.

Do not force:

```text
NSAppearanceNameAqua
NSAppearanceNameDarkAqua
```

unless a future explicitly requested feature allows appearance overrides.

### Typography

Use system font APIs.

Examples:

```objc
[NSFont systemFontOfSize:13 weight:NSFontWeightRegular]
[NSFont systemFontOfSize:13 weight:NSFontWeightSemibold]
[NSFont monospacedSystemFontOfSize:13 weight:NSFontWeightRegular]
```

Do not bundle San Francisco or hardcode a system font by family name.

Color values should use the system monospaced font.

### Layout

Use Auto Layout.

Do not position normal interface elements using fixed frame coordinates.

Fixed coordinates are acceptable only where genuinely required for custom drawing.

The interface must remain usable at the documented minimum window size.

### Invalid input

Invalid color input must:

- never crash the application
- never produce undefined color data
- never corrupt an existing valid palette
- provide subtle native visual feedback

### Midpoints

Valid midpoint range:

```text
1–10
```

Palette size:

```text
2 endpoint colors + 1–10 midpoint colors
```

Maximum:

```text
12 colors
```

Do not silently expand this range as part of a bug fix.

### Palette generation

Palette generation uses RGB interpolation.

A successfully generated palette includes both endpoint colors.

Generating a new palette replaces the previous generated palette.

Do not introduce alternative interpolation algorithms into version 1.0.x as a silent
behavior change.

### Web-safe picker

The web-safe picker uses combinations of:

```text
00
33
66
99
CC
FF
```

These are literal color data and must remain unchanged between Light and Dark Mode.

The picker should interact with the currently active color input rather than maintaining
a separate global color state.

---

## Assets and resources

Do not assume the project requires an asset catalog or `Assets/` directory.

Color Blender currently favors programmatic AppKit UI and should not contain unused
resource directories merely to imitate a conventional Xcode project layout.

If a future feature genuinely requires application resources, add only the resources
needed by that feature and ensure the Makefile copies or bundles them correctly.

Never introduce `.xcassets` as a build requirement unless the development architecture
is explicitly changed.

---

## Documentation

Keep the following documents aligned with actual repository behavior:

```text
README.md
DESIGN.md
CLAUDE.md
```

`README.md` describes the project for developers and repository visitors.

`DESIGN.md` defines interface, visual, behavioral, and architectural design constraints.

`CLAUDE.md` provides implementation guidance for Claude Code.

Documentation must describe the repository as it actually exists.

Do not document aspirational commands, files, test infrastructure, Xcode projects, or
features as though they already exist.

When implementation and documentation disagree, inspect the implementation and relevant
design requirements before changing either one.

---

## Scope discipline

Version 1.0.x is maintenance-oriented.

When fixing a bug:

1. Preserve established behavior unless the behavior itself is the bug.
2. Avoid unrelated refactors.
3. Do not introduce new user-facing functionality as part of a patch.
4. Keep the Makefile-based build working.
5. Keep Light/Dark Mode behavior intact.
6. Preserve supported input formats.
7. Preserve the 1–10 midpoint range.
8. Preserve RGB interpolation unless intentionally working on a future feature version.

Do not turn a small bug fix into an architectural rewrite.

---

## Versioning

Color Blender follows Semantic Versioning:

```text
MAJOR.MINOR.PATCH
```

Example:

```text
1.0.0
```

### PATCH

Use a patch release for backward-compatible fixes and maintenance that do not add
user-facing functionality or break established behavior.

Examples:

```text
1.0.0 → 1.0.1
```

for:

- bug fixes
- documentation corrections
- removal of unused files
- build-script corrections that preserve behavior
- internal maintenance

### MINOR

Use a minor release for backward-compatible new functionality.

Example:

```text
1.0.x → 1.1.0
```

Potential examples include future optional features such as additional palette tools or
export functionality that preserve existing behavior.

### MAJOR

Use a major release when introducing incompatible changes to established behavior,
interfaces, formats, or interaction models.

Example:

```text
1.x.x → 2.0.0
```

---

## Version 1.0.0 design freeze

Per `DESIGN.md` §21, version 1.0.0 establishes the baseline design and behavior of
Color Blender.

Before the initial `v1.0.0` release/tag is created, documentation cleanup, removal of
unused files, and repository organization are considered part of preparing version
1.0.0 and do not require incrementing the version.

After `v1.0.0` has been released:

- compatible bug fixes and maintenance → PATCH
- backward-compatible functionality → MINOR
- incompatible established-behavior changes → MAJOR

Do not increment the version merely because documentation was edited during preparation
of the initial 1.0.0 release.

---

## Working principles

When modifying this repository:

1. Inspect the existing implementation before assuming how something works.
2. Prefer the smallest change that correctly solves the problem.
3. Preserve the separation between App, Controllers, Models, Services, and Views.
4. Keep the application buildable through `make`.
5. Do not introduce Xcode dependencies.
6. Use native AppKit behavior instead of web-style or custom replacements.
7. Preserve automatic Light/Dark Mode support.
8. Keep documentation synchronized with actual behavior.
9. Do not claim tests were executed unless an actual test command was run successfully.
10. Do not add functionality outside the requested version scope.
