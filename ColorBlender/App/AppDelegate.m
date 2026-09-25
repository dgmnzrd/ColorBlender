#import "AppDelegate.h"
#import "MainViewController.h"

@implementation AppDelegate

#pragma mark - Application Lifecycle

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    [self setupMainMenu];

    /*
     La interfaz ahora utiliza dos columnas:

     Izquierda:
     - Color 1
     - Color 2
     - Format
     - Midpoints
     - Actions
     - Palette

     Derecha:
     - Web Safe Colors

     1050 pt proporciona espacio suficiente para mantener
     ambas columnas sin comprimir los controles.
    */

    NSRect frame =
        NSMakeRect(0, 0, 1050, 620);

    NSWindowStyleMask style =
        NSWindowStyleMaskTitled |
        NSWindowStyleMaskClosable |
        NSWindowStyleMaskMiniaturizable |
        NSWindowStyleMaskResizable;

    self.window =
        [[NSWindow alloc]
            initWithContentRect:frame
                      styleMask:style
                        backing:NSBackingStoreBuffered
                          defer:NO];

    self.window.title =
        @"Color Blender";

    /*
     Permitimos reducir ligeramente la ventana, pero evitamos
     tamaños en los que Format, Midpoints y Actions comiencen
     a superponerse.
    */

    self.window.minSize =
        NSMakeSize(990, 560);


    /*
     Controller principal.
    */

    self.mainViewController =
        [[MainViewController alloc] init];

    self.window.contentViewController =
        self.mainViewController;


    /*
     Presentación inicial de la ventana.
    */

    [self.window center];

    [self.window makeKeyAndOrderFront:nil];

    [NSApp activateIgnoringOtherApps:YES];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:
    (NSApplication *)sender {

    return YES;
}

#pragma mark - Main Menu

- (void)setupMainMenu {

    NSMenu *mainMenu =
        [[NSMenu alloc] initWithTitle:@"Main Menu"];


    // =========================================================
    // Application Menu
    // =========================================================

    NSMenuItem *applicationMenuItem =
        [[NSMenuItem alloc] init];

    [mainMenu addItem:applicationMenuItem];


    NSMenu *applicationMenu =
        [[NSMenu alloc]
            initWithTitle:@"Color Blender"];


    // About

    NSMenuItem *aboutItem =
        [[NSMenuItem alloc]
            initWithTitle:@"About Color Blender"
                   action:@selector(orderFrontStandardAboutPanel:)
            keyEquivalent:@""];

    [applicationMenu addItem:aboutItem];


    [applicationMenu addItem:
        [NSMenuItem separatorItem]];


    // Hide

    NSMenuItem *hideItem =
        [[NSMenuItem alloc]
            initWithTitle:@"Hide Color Blender"
                   action:@selector(hide:)
            keyEquivalent:@"h"];

    [applicationMenu addItem:hideItem];


    // Hide Others

    NSMenuItem *hideOthersItem =
        [[NSMenuItem alloc]
            initWithTitle:@"Hide Others"
                   action:@selector(hideOtherApplications:)
            keyEquivalent:@"h"];

    hideOthersItem.keyEquivalentModifierMask =
        NSEventModifierFlagCommand |
        NSEventModifierFlagOption;

    [applicationMenu addItem:hideOthersItem];


    // Show All

    NSMenuItem *showAllItem =
        [[NSMenuItem alloc]
            initWithTitle:@"Show All"
                   action:@selector(unhideAllApplications:)
            keyEquivalent:@""];

    [applicationMenu addItem:showAllItem];


    [applicationMenu addItem:
        [NSMenuItem separatorItem]];


    // Quit

    NSMenuItem *quitItem =
        [[NSMenuItem alloc]
            initWithTitle:@"Quit Color Blender"
                   action:@selector(terminate:)
            keyEquivalent:@"q"];

    [applicationMenu addItem:quitItem];


    applicationMenuItem.submenu =
        applicationMenu;


    // =========================================================
    // Edit Menu
    // =========================================================

    NSMenuItem *editMenuItem =
        [[NSMenuItem alloc] init];

    [mainMenu addItem:editMenuItem];


    NSMenu *editMenu =
        [[NSMenu alloc]
            initWithTitle:@"Edit"];


    // ---------------------------------------------------------
    // Undo
    // ---------------------------------------------------------

    NSMenuItem *undoItem =
        [[NSMenuItem alloc]
            initWithTitle:@"Undo"
                   action:@selector(undo:)
            keyEquivalent:@"z"];

    [editMenu addItem:undoItem];


    // ---------------------------------------------------------
    // Redo
    // ---------------------------------------------------------

    NSMenuItem *redoItem =
        [[NSMenuItem alloc]
            initWithTitle:@"Redo"
                   action:@selector(redo:)
            keyEquivalent:@"z"];

    redoItem.keyEquivalentModifierMask =
        NSEventModifierFlagCommand |
        NSEventModifierFlagShift;

    [editMenu addItem:redoItem];


    [editMenu addItem:
        [NSMenuItem separatorItem]];


    // ---------------------------------------------------------
    // Cut - Cmd + X
    // ---------------------------------------------------------

    NSMenuItem *cutItem =
        [[NSMenuItem alloc]
            initWithTitle:@"Cut"
                   action:@selector(cut:)
            keyEquivalent:@"x"];

    [editMenu addItem:cutItem];


    // ---------------------------------------------------------
    // Copy - Cmd + C
    // ---------------------------------------------------------

    NSMenuItem *copyItem =
        [[NSMenuItem alloc]
            initWithTitle:@"Copy"
                   action:@selector(copy:)
            keyEquivalent:@"c"];

    [editMenu addItem:copyItem];


    // ---------------------------------------------------------
    // Paste - Cmd + V
    // ---------------------------------------------------------

    NSMenuItem *pasteItem =
        [[NSMenuItem alloc]
            initWithTitle:@"Paste"
                   action:@selector(paste:)
            keyEquivalent:@"v"];

    [editMenu addItem:pasteItem];


    [editMenu addItem:
        [NSMenuItem separatorItem]];


    // ---------------------------------------------------------
    // Select All - Cmd + A
    // ---------------------------------------------------------

    NSMenuItem *selectAllItem =
        [[NSMenuItem alloc]
            initWithTitle:@"Select All"
                   action:@selector(selectAll:)
            keyEquivalent:@"a"];

    [editMenu addItem:selectAllItem];


    editMenuItem.submenu =
        editMenu;


    // =========================================================
    // Window Menu
    // =========================================================

    NSMenuItem *windowMenuItem =
        [[NSMenuItem alloc] init];

    [mainMenu addItem:windowMenuItem];


    NSMenu *windowMenu =
        [[NSMenu alloc]
            initWithTitle:@"Window"];


    // ---------------------------------------------------------
    // Minimize
    // ---------------------------------------------------------

    NSMenuItem *minimizeItem =
        [[NSMenuItem alloc]
            initWithTitle:@"Minimize"
                   action:@selector(performMiniaturize:)
            keyEquivalent:@"m"];

    [windowMenu addItem:minimizeItem];


    // ---------------------------------------------------------
    // Zoom
    // ---------------------------------------------------------

    NSMenuItem *zoomItem =
        [[NSMenuItem alloc]
            initWithTitle:@"Zoom"
                   action:@selector(performZoom:)
            keyEquivalent:@""];

    [windowMenu addItem:zoomItem];


    windowMenuItem.submenu =
        windowMenu;


    /*
     Registramos este menú como el Window Menu oficial
     de la aplicación.
    */

    [NSApp setWindowsMenu:windowMenu];


    // =========================================================
    // Install Main Menu
    // =========================================================

    [NSApp setMainMenu:mainMenu];
}

@end