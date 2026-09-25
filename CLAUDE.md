# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Color Blender is a native macOS utility (Objective-C + AppKit, no web UI framework) that generates
RGB-interpolated color palettes between two endpoint colors. It supports HEX / RGB / RGB% input,
1–10 midpoint colors (max 12-color palette), and a classic web-safe color picker.

## Build & run

There is **no Xcode project/workspace** in this repo (despite the "Building" section in README.md,
which describes an aspirational Xcode workflow). The actual build is driven by the `Makefile`, which
invokes `clang` directly against `ColorBlender/**/*.m`:

```sh
make          # builds build/ColorBlender.app
make run      # builds and opens the app
make clean    # removes build/
make rebuild  # clean + all
```

There is no `test` target. `Tests/ColorBlenderEngineTests.m` is an XCTest case, but it is not compiled
or linked by the Makefile (XCTest needs an Xcode test bundle/scheme, and none exists here). If asked to
run or add tests, either wire up an actual Xcode project/scheme first, or check with the user for how
they want tests executed — don't assume `make` or any existing command runs them.

## Architecture

Source is organized by responsibility under `ColorBlender/`, and each layer has a single, strict job
(enforced in `DESIGN.md` §18):

- **`App/`** — `AppDelegate` (window creation, main menu construction) and `main.m`. No layout or color
  logic belongs here.
- **`Controllers/`** — `MainViewController` is the sole coordinator. It owns all subviews, is the
  delegate for `ColorInputView` and `WebSafeColorPickerView`, and implements the `Blend`/`Clear`
  actions. It does not implement color math itself.
- **`Models/`** — `CBColor` represents a color independently of AppKit's `NSColor`: parses/serializes
  HEX, RGB, and RGB% strings (`CBColorFormat` enum) and exposes `-nsColor` for rendering.
- **`Services/`** — `ColorBlenderEngine` does the actual RGB interpolation
  (`+blendFromColor:toColor:midpoints:`), decoupled from UI and app lifecycle so it stays reusable/testable.
- **`Views/`** — `ColorInputView` (single color input + preview + delegate callbacks),
  `PaletteView` (renders the generated palette), `WebSafeColorPickerView` (the web-safe grid, also
  delegate-based). Views never do interpolation or app-lifecycle work.

Views communicate upward to `MainViewController` via delegate protocols
(`ColorInputViewDelegate`, `WebSafeColorPickerViewDelegate`) rather than through a shared mutable
app state — `MainViewController` is the single point of coordination.

## Design constraints (see `DESIGN.md` for full detail)

These are enforced conventions, not suggestions — violating them is a regression against the design doc:

- **Never hardcode UI colors.** Use `NSColor` semantic colors (`labelColor`, `windowBackgroundColor`,
  `controlAccentColor`, etc.) for all interface chrome so Light/Dark Mode and accent color keep working.
  The only literal colors allowed are actual user color *data* (palette swatches, web-safe grid colors)
  and computed contrast colors for text drawn over a swatch.
- **Native AppKit controls only** (`NSTextField`, `NSButton`, `NSSegmentedControl`, `NSStepper`,
  `NSStackView`, ...) — don't hand-roll custom control replacements.
- **System font APIs only** (`NSFont.systemFontOfSize:weight:`, monospaced system font for color
  values) — never bundle or hardcode a specific font.
- **Auto Layout only** — no fixed-frame positioning except where custom drawing requires it.
- Invalid color input must degrade gracefully (subtle native feedback) and must never crash or corrupt
  an already-generated palette.
- Midpoints are clamped to 1–10 (palette size 2–12); this range is enforced by the midpoint stepper.

## Versioning

Semantic Versioning. Per `DESIGN.md` §20, version 1.0.0 is a **design freeze**: bug fixes that preserve
documented behavior are patches, backward-compatible additions are minor versions, and any change to
the interaction model, supported formats, or established behavior should be treated as a candidate for
a future major version rather than folded silently into 1.x.
