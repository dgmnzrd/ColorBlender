# Color Blender — Design System

## 1. Design direction

Color Blender is a native macOS utility.

The interface should feel at home on macOS 27 and use native AppKit
components and system behaviors whenever possible.

Design priorities:

1. Native macOS appearance
2. Simplicity
3. Clear visual hierarchy
4. Compact utility-oriented layout
5. Automatic Light/Dark Mode support
6. Accessibility
7. Minimal use of custom drawing

The application should not imitate a web application.

---

## 2. Appearance

Color Blender supports both macOS appearances:

- Light Mode
- Dark Mode

The application must follow the system appearance automatically.

Do not force:

NSAppearanceNameAqua
NSAppearanceNameDarkAqua

unless a future feature explicitly allows overriding the system setting.

Views should inherit their appearance from NSApplication / NSWindow.

---

## 3. Semantic colors

System UI colors must use NSColor semantic colors.

### Backgrounds

Primary window:

NSColor.windowBackgroundColor

Control backgrounds:

NSColor.controlBackgroundColor

Secondary surfaces when needed:

NSColor.underPageBackgroundColor

### Text

Primary:

NSColor.labelColor

Secondary:

NSColor.secondaryLabelColor

Tertiary:

NSColor.tertiaryLabelColor

Disabled:

NSColor.disabledControlTextColor

### Borders and separators

NSColor.separatorColor

NSColor.gridColor

### Selection and accent

NSColor.controlAccentColor

NSColor.selectedControlColor

NSColor.keyboardFocusIndicatorColor

---

## 4. Important color rule

Never use fixed colors for standard interface elements.

Avoid:

[NSColor whiteColor]
[NSColor blackColor]

and fixed UI colors such as:

#FFFFFF
#000000
#F5F5F5
#222222

because these may become unreadable when the system appearance changes.

Exceptions are colors representing actual user color data.

For example:

#FF0000
#5B21B6
#FF5B00

must remain exactly those colors because they are Color Blender data,
not interface colors.

Literal black or white may also be used when they are part of the
user's actual color data or when calculated as a contrast color for
content displayed over a literal color swatch.

---

## 5. Typography

Use San Francisco through the system font APIs.

Never bundle or manually specify the San Francisco font.

### Window title / page title

NSFont.systemFontOfSize:28 weight:NSFontWeightSemibold

### Section title

NSFont.systemFontOfSize:13 weight:NSFontWeightSemibold

### Standard labels

NSFont.systemFontOfSize:13 weight:NSFontWeightRegular

### Secondary labels

NSFont.systemFontOfSize:11 weight:NSFontWeightRegular

### Color values

Use the system monospaced font:

NSFont.monospacedSystemFontOfSize:13
                           weight:NSFontWeightRegular

Examples:

#5B21B6
rgb(91,33,182)
rgb(36%,13%,71%)

---

## 6. Layout

Main content maximum comfortable width:

760–900 pt

Minimum window size:

620 × 500 pt

Recommended initial window:

760 × 620 pt

Outer content padding:

32 pt

Section spacing:

24 pt

Related control spacing:

8–12 pt

Small internal spacing:

6–8 pt

Use Auto Layout.

Do not position interface elements using fixed frame coordinates except
where required for custom drawing.

The interface must remain usable when the window is resized to its
minimum supported size.

Content that cannot reasonably fit vertically should be hosted in a
native NSScrollView rather than clipped.

---

## 7. Main structure

The main interface is divided into:

Color Blender

[ Input section ]

Color 1
[color preview] [value]

Color 2
[color preview] [value]

Format                 Midpoints
[HEX | RGB | RGB%]     [value]

[ Blend Colors ] [ Clear ]

[ Palette section ]

Palette

[color visualization]

[color rows]

[ Web-safe color picker ]

---

## 8. Controls

Prefer native AppKit controls.

Use:

NSTextField
NSButton
NSSegmentedControl
NSStepper
NSScrollView
NSStackView
NSColorPanel when appropriate

Avoid recreating native controls manually.

Buttons should use native bezel styles and system accent colors.

Controls must expose appropriate enabled, disabled, focus and keyboard
states using native AppKit behavior.

---

## 9. Color input

Each ColorInputView contains:

- descriptive label
- color preview
- editable color value

Example:

Color 1

┌────┐  ┌─────────────────────────┐
│    │  │ #5B21B6                 │
└────┘  └─────────────────────────┘

The color preview displays the literal color selected by the user.

The text field uses a monospaced system font.

Input parsing depends on the currently selected format.

Supported formats are:

- HEX
- RGB
- RGB%

Invalid input must never crash the application or generate an invalid
palette.

Invalid values should provide subtle native visual feedback and keep
the user in control of correcting the value.

Changing the selected format updates the textual representation of
valid colors without changing the underlying colors.

---

## 10. Midpoints

The application supports between 1 and 10 midpoint colors.

The midpoint control must not allow values outside this range.

A native NSStepper may be used together with an editable or display
field.

The selected midpoint count determines the number of colors generated
between Color 1 and Color 2.

Total palette size:

2 endpoint colors
+
1–10 midpoint colors

Maximum:

12 colors

---

## 11. Palette

PaletteView displays every generated color in interpolation order.

Both endpoint colors must always be represented in a successfully
generated palette.

Each color should expose:

- visual swatch
- textual representation

Example:

■  #5B21B6
■  #7A2B92
■  #993568
■  #B83F3E
■  #D74A1A
■  #FF5B00

Color values should use monospaced typography.

The textual representation follows the currently selected output
format.

Regenerating the palette replaces the previous palette rather than
appending to it.

---

## 12. Color contrast

Color swatches represent literal user data and therefore do not change
between Light and Dark Mode.

Any text rendered over a color swatch must choose an appropriate
foreground color based on the swatch luminance.

Prefer avoiding text directly over arbitrary colors when possible.

Contrast calculations are presentation logic only and must never
modify the underlying color value.

---

## 13. Web-safe color picker

The WebSafeColorPickerView reproduces the original Color Blender
web-safe color grid.

The grid contains the standard web-safe RGB combinations based on:

00
33
66
99
CC
FF

Selecting a web-safe color must return the literal selected color to
the application.

The grid is color data, not system interface chrome, so its colors must
remain identical in Light and Dark Mode.

Selection feedback should remain visible without permanently altering
the selected color.

The picker must integrate with the currently active color input rather
than maintaining an independent application color state.

---

## 14. Actions

### Blend Colors

Blend Colors validates both input colors and the midpoint count.

When all values are valid, the application generates a new palette
using RGB interpolation.

Invalid input must not replace a previously valid palette with corrupt
or undefined data.

### Clear

Clear returns the working interface to its initial state.

It clears user-entered color values and removes the generated palette.

The application remains ready for new input immediately after the
operation.

Clear must not alter system appearance or application preferences.

---

## 15. Materials

Native macOS materials may be used sparingly for surfaces where they
improve hierarchy.

Use NSVisualEffectView rather than manually simulating transparency or
blur.

Materials must remain readable in both Light and Dark Mode.

Do not overuse glass or translucency.

Color data itself must never become translucent because of the UI
material.

---

## 16. Window

The application uses a standard native macOS window.

Required behaviors:

- Close
- Minimize
- Resize
- Full native window movement
- Retina rendering
- Light/Dark Mode
- System accent color
- Keyboard focus behavior

The window should not implement custom traffic-light buttons.

Window behavior should remain controlled by AppKit whenever possible.

---

## 17. Accessibility

Controls must remain usable with:

- Light Mode
- Dark Mode
- different system accent colors
- keyboard navigation
- increased contrast where possible

Do not communicate information using color alone.

Every generated color must also expose its textual color value.

Interactive custom views should provide appropriate accessibility
labels or descriptions when native controls do not provide them
automatically.

Keyboard focus must remain visible.

---

## 18. Architecture

Visual responsibilities belong in:

Views/

Application interaction belongs in:

Controllers/

Color representation belongs in:

Models/

Color interpolation belongs in:

Services/

App lifecycle belongs in:

App/

Do not place visual layout code in AppDelegate.

Views should not contain color interpolation or application lifecycle
logic.

Controllers coordinate user interaction without becoming responsible
for low-level color mathematics.

Color parsing, representation and interpolation should remain reusable
outside the interface layer.

---

## 19. V1 scope

Version 1 reproduces the functionality of the original Color Blender.

V1 includes:

- HEX
- RGB
- RGB%
- Color 1
- Color 2
- 1–10 midpoints
- RGB interpolation
- generated palette
- original web-safe color grid
- Blend
- Clear
- automatic Light/Dark Mode
- native macOS interface
- keyboard-compatible controls
- invalid-input handling

The visual design is native macOS rather than a recreation of the
original website appearance.

New color algorithms, additional color spaces, export systems and
advanced palette features are outside V1.

---

## 20. Version 1.0.0 design freeze

This document defines the interface and visual behavior expected for
Color Blender 1.0.0.

Changes that fix implementation defects while preserving these
behaviors may be released as patch versions.

Backward-compatible additions may be introduced in minor versions.

Major changes to the application's interaction model, supported
formats or established behavior should be evaluated for a future major
version.