#import "MainViewController.h"

#import "CBColor.h"
#import "ColorBlenderEngine.h"
#import "ColorInputView.h"
#import "PaletteView.h"
#import "WebSafeColorPickerView.h"

@interface MainViewController ()
    <ColorInputViewDelegate,
     WebSafeColorPickerViewDelegate>

@property (nonatomic, strong) NSTextField *titleLabel;
@property (nonatomic, strong) NSTextField *subtitleLabel;

@property (nonatomic, strong) ColorInputView *color1Input;
@property (nonatomic, strong) ColorInputView *color2Input;

@property (nonatomic, strong) NSSegmentedControl *formatControl;

@property (nonatomic, strong) NSTextField *midpointsField;
@property (nonatomic, strong) NSStepper *midpointsStepper;

@property (nonatomic, strong) NSButton *clearButton;

@property (nonatomic, strong) PaletteView *paletteView;

@property (nonatomic, strong) NSView *verticalSeparator;

@property (nonatomic, strong) NSTextField *webSafeTitleLabel;
@property (nonatomic, strong) NSTextField *webSafeSubtitleLabel;

@property (nonatomic, strong)
    NSSegmentedControl *webSafeTargetControl;

@property (nonatomic, strong)
    WebSafeColorPickerView *webSafePicker;

@property (nonatomic, assign) CBColorFormat currentFormat;

@end


@implementation MainViewController

#pragma mark - Lifecycle

- (void)loadView {

    self.view =
        [[NSView alloc]
            initWithFrame:NSMakeRect(0, 0, 1050, 620)];
}


- (void)viewDidLoad {

    [super viewDidLoad];

    self.currentFormat =
        CBColorFormatHex;

    [self setupInterface];

    [self updatePlaceholders];
}


#pragma mark - Interface

- (void)setupInterface {

    // =========================================================
    // Title
    // =========================================================

    self.titleLabel =
        [NSTextField labelWithString:@"Color Blender"];

    self.titleLabel.font =
        [NSFont systemFontOfSize:28
                          weight:NSFontWeightSemibold];

    self.titleLabel.translatesAutoresizingMaskIntoConstraints =
        NO;


    // =========================================================
    // Subtitle
    // =========================================================

    self.subtitleLabel =
        [NSTextField labelWithString:
            @"Blend two colors and generate intermediate values."];

    self.subtitleLabel.font =
        [NSFont systemFontOfSize:13
                          weight:NSFontWeightRegular];

    self.subtitleLabel.textColor =
        NSColor.secondaryLabelColor;

    self.subtitleLabel.translatesAutoresizingMaskIntoConstraints =
        NO;


    // =========================================================
    // Color Inputs
    // =========================================================

    self.color1Input =
        [[ColorInputView alloc]
            initWithTitle:@"Color 1"];

    self.color2Input =
        [[ColorInputView alloc]
            initWithTitle:@"Color 2"];

    self.color1Input.delegate =
        self;

    self.color2Input.delegate =
        self;


    // =========================================================
    // Format
    // =========================================================

    NSTextField *formatLabel =
        [NSTextField labelWithString:@"Format"];

    formatLabel.font =
        [NSFont systemFontOfSize:13
                          weight:NSFontWeightSemibold];

    formatLabel.translatesAutoresizingMaskIntoConstraints =
        NO;


    self.formatControl =
        [NSSegmentedControl
            segmentedControlWithLabels:@[
                @"HEX",
                @"RGB",
                @"RGB%"
            ]
            trackingMode:NSSegmentSwitchTrackingSelectOne
            target:self
            action:@selector(formatChanged:)];

    self.formatControl.selectedSegment =
        0;

    self.formatControl.translatesAutoresizingMaskIntoConstraints =
        NO;


    // =========================================================
    // Midpoints
    // =========================================================

    NSTextField *midpointsLabel =
        [NSTextField labelWithString:@"Midpoints"];

    midpointsLabel.font =
        [NSFont systemFontOfSize:13
                          weight:NSFontWeightSemibold];

    midpointsLabel.translatesAutoresizingMaskIntoConstraints =
        NO;


    self.midpointsField =
        [[NSTextField alloc]
            initWithFrame:NSZeroRect];

    self.midpointsField.stringValue =
        @"1";

    self.midpointsField.alignment =
        NSTextAlignmentCenter;

    self.midpointsField.editable =
        NO;

    self.midpointsField.translatesAutoresizingMaskIntoConstraints =
        NO;


    self.midpointsStepper =
        [[NSStepper alloc]
            initWithFrame:NSZeroRect];

    self.midpointsStepper.minValue =
        1;

    self.midpointsStepper.maxValue =
        10;

    self.midpointsStepper.increment =
        1;

    self.midpointsStepper.integerValue =
        1;

    self.midpointsStepper.target =
        self;

    self.midpointsStepper.action =
        @selector(midpointsChanged:);

    self.midpointsStepper.translatesAutoresizingMaskIntoConstraints =
        NO;


    // =========================================================
    // Clear
    // =========================================================

    self.clearButton =
        [NSButton buttonWithTitle:@"Clear"
                           target:self
                           action:@selector(clearColors:)];

    self.clearButton.bezelStyle =
        NSBezelStyleAccessoryBarAction;

    self.clearButton.translatesAutoresizingMaskIntoConstraints =
        NO;


    // =========================================================
    // Palette
    // =========================================================

    self.paletteView =
        [[PaletteView alloc]
            initWithFrame:NSZeroRect];


    // =========================================================
    // Vertical Separator
    // =========================================================

    self.verticalSeparator =
        [[NSView alloc]
            initWithFrame:NSZeroRect];

    self.verticalSeparator.wantsLayer =
        YES;

    self.verticalSeparator.layer.backgroundColor =
        NSColor.separatorColor.CGColor;

    self.verticalSeparator.translatesAutoresizingMaskIntoConstraints =
        NO;


    // =========================================================
    // Web Safe Colors
    // =========================================================

    self.webSafeTitleLabel =
        [NSTextField labelWithString:@"Web Safe Colors"];

    self.webSafeTitleLabel.font =
        [NSFont systemFontOfSize:13
                          weight:NSFontWeightSemibold];

    self.webSafeTitleLabel.translatesAutoresizingMaskIntoConstraints =
        NO;


    self.webSafeSubtitleLabel =
        [NSTextField labelWithString:
            @"Select a target, then choose a color."];

    self.webSafeSubtitleLabel.font =
        [NSFont systemFontOfSize:11
                          weight:NSFontWeightRegular];

    self.webSafeSubtitleLabel.textColor =
        NSColor.secondaryLabelColor;

    self.webSafeSubtitleLabel.translatesAutoresizingMaskIntoConstraints =
        NO;


    self.webSafeTargetControl =
        [NSSegmentedControl
            segmentedControlWithLabels:@[
                @"Color 1",
                @"Color 2"
            ]
            trackingMode:NSSegmentSwitchTrackingSelectOne
            target:nil
            action:nil];

    self.webSafeTargetControl.selectedSegment =
        0;

    self.webSafeTargetControl.translatesAutoresizingMaskIntoConstraints =
        NO;


    self.webSafePicker =
        [[WebSafeColorPickerView alloc]
            initWithFrame:NSZeroRect];

    self.webSafePicker.delegate =
        self;


    // =========================================================
    // Add Subviews
    // =========================================================

    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.subtitleLabel];

    [self.view addSubview:self.color1Input];
    [self.view addSubview:self.color2Input];

    [self.view addSubview:formatLabel];
    [self.view addSubview:self.formatControl];

    [self.view addSubview:midpointsLabel];
    [self.view addSubview:self.midpointsField];
    [self.view addSubview:self.midpointsStepper];

    [self.view addSubview:self.clearButton];

    [self.view addSubview:self.paletteView];

    [self.view addSubview:self.verticalSeparator];

    [self.view addSubview:self.webSafeTitleLabel];
    [self.view addSubview:self.webSafeSubtitleLabel];
    [self.view addSubview:self.webSafeTargetControl];
    [self.view addSubview:self.webSafePicker];


    // =========================================================
    // Layout
    // =========================================================

    [NSLayoutConstraint activateConstraints:@[

        // -----------------------------------------------------
        // Header
        // -----------------------------------------------------

        [self.titleLabel.topAnchor
            constraintEqualToAnchor:self.view.topAnchor
                           constant:32],

        [self.titleLabel.leadingAnchor
            constraintEqualToAnchor:self.view.leadingAnchor
                           constant:32],


        [self.subtitleLabel.topAnchor
            constraintEqualToAnchor:self.titleLabel.bottomAnchor
                           constant:6],

        [self.subtitleLabel.leadingAnchor
            constraintEqualToAnchor:self.titleLabel.leadingAnchor],


        // -----------------------------------------------------
        // Vertical Separator
        // -----------------------------------------------------

        [self.verticalSeparator.topAnchor
            constraintEqualToAnchor:self.color1Input.topAnchor],

        [self.verticalSeparator.bottomAnchor
            constraintEqualToAnchor:self.view.bottomAnchor
                           constant:-32],

        [self.verticalSeparator.leadingAnchor
            constraintEqualToAnchor:self.view.leadingAnchor
                           constant:700],

        [self.verticalSeparator.widthAnchor
            constraintEqualToConstant:1],


        // -----------------------------------------------------
        // Color 1
        // -----------------------------------------------------

        [self.color1Input.topAnchor
            constraintEqualToAnchor:self.subtitleLabel.bottomAnchor
                           constant:32],

        [self.color1Input.leadingAnchor
            constraintEqualToAnchor:self.view.leadingAnchor
                           constant:32],

        [self.color1Input.trailingAnchor
            constraintEqualToAnchor:self.verticalSeparator.leadingAnchor
                           constant:-24],


        // -----------------------------------------------------
        // Color 2
        // -----------------------------------------------------

        [self.color2Input.topAnchor
            constraintEqualToAnchor:self.color1Input.bottomAnchor
                           constant:20],

        [self.color2Input.leadingAnchor
            constraintEqualToAnchor:self.color1Input.leadingAnchor],

        [self.color2Input.trailingAnchor
            constraintEqualToAnchor:self.color1Input.trailingAnchor],


        // -----------------------------------------------------
        // Format
        // -----------------------------------------------------

        [formatLabel.topAnchor
            constraintEqualToAnchor:self.color2Input.bottomAnchor
                           constant:28],

        [formatLabel.leadingAnchor
            constraintEqualToAnchor:self.color1Input.leadingAnchor],


        [self.formatControl.topAnchor
            constraintEqualToAnchor:formatLabel.bottomAnchor
                           constant:8],

        [self.formatControl.leadingAnchor
            constraintEqualToAnchor:formatLabel.leadingAnchor],

        [self.formatControl.widthAnchor
            constraintEqualToConstant:220],


        // -----------------------------------------------------
        // Midpoints
        // -----------------------------------------------------

        [midpointsLabel.topAnchor
            constraintEqualToAnchor:formatLabel.topAnchor],

        [midpointsLabel.leadingAnchor
            constraintEqualToAnchor:self.formatControl.trailingAnchor
                           constant:24],


        [self.midpointsField.topAnchor
            constraintEqualToAnchor:self.formatControl.topAnchor],

        [self.midpointsField.leadingAnchor
            constraintEqualToAnchor:midpointsLabel.leadingAnchor],

        [self.midpointsField.widthAnchor
            constraintEqualToConstant:48],


        [self.midpointsStepper.leadingAnchor
            constraintEqualToAnchor:self.midpointsField.trailingAnchor
                           constant:6],

        [self.midpointsStepper.centerYAnchor
            constraintEqualToAnchor:self.midpointsField.centerYAnchor],


        // -----------------------------------------------------
        // Clear
        // -----------------------------------------------------

        [self.clearButton.leadingAnchor
            constraintEqualToAnchor:self.midpointsStepper.trailingAnchor
                           constant:24],

        [self.clearButton.centerYAnchor
            constraintEqualToAnchor:self.formatControl.centerYAnchor],

        [self.clearButton.trailingAnchor
            constraintLessThanOrEqualToAnchor:self.color1Input.trailingAnchor],


        // -----------------------------------------------------
        // Palette
        // -----------------------------------------------------

        [self.paletteView.topAnchor
            constraintEqualToAnchor:self.formatControl.bottomAnchor
                           constant:30],

        [self.paletteView.leadingAnchor
            constraintEqualToAnchor:self.color1Input.leadingAnchor],

        [self.paletteView.trailingAnchor
            constraintEqualToAnchor:self.color1Input.trailingAnchor],

        [self.paletteView.bottomAnchor
            constraintEqualToAnchor:self.view.bottomAnchor
                           constant:-32],


        // -----------------------------------------------------
        // Web Safe Title
        // -----------------------------------------------------

        [self.webSafeTitleLabel.topAnchor
            constraintEqualToAnchor:self.color1Input.topAnchor],

        [self.webSafeTitleLabel.leadingAnchor
            constraintEqualToAnchor:self.verticalSeparator.trailingAnchor
                           constant:24],

        [self.webSafeTitleLabel.trailingAnchor
            constraintLessThanOrEqualToAnchor:self.view.trailingAnchor
                                      constant:-32],


        // -----------------------------------------------------
        // Web Safe Subtitle
        // -----------------------------------------------------

        [self.webSafeSubtitleLabel.topAnchor
            constraintEqualToAnchor:self.webSafeTitleLabel.bottomAnchor
                           constant:4],

        [self.webSafeSubtitleLabel.leadingAnchor
            constraintEqualToAnchor:self.webSafeTitleLabel.leadingAnchor],

        [self.webSafeSubtitleLabel.trailingAnchor
            constraintLessThanOrEqualToAnchor:self.view.trailingAnchor
                                      constant:-32],


        // -----------------------------------------------------
        // Web Safe Target
        // -----------------------------------------------------

        [self.webSafeTargetControl.topAnchor
            constraintEqualToAnchor:self.webSafeSubtitleLabel.bottomAnchor
                           constant:12],

        [self.webSafeTargetControl.leadingAnchor
            constraintEqualToAnchor:self.webSafeTitleLabel.leadingAnchor],

        [self.webSafeTargetControl.widthAnchor
            constraintEqualToConstant:220],


        // -----------------------------------------------------
        // Web Safe Picker
        // -----------------------------------------------------

        [self.webSafePicker.topAnchor
            constraintEqualToAnchor:self.webSafeTargetControl.bottomAnchor
                           constant:14],

        [self.webSafePicker.leadingAnchor
            constraintEqualToAnchor:self.webSafeTitleLabel.leadingAnchor],

        [self.webSafePicker.trailingAnchor
            constraintLessThanOrEqualToAnchor:self.view.trailingAnchor
                                      constant:-32],

        [self.webSafePicker.bottomAnchor
            constraintLessThanOrEqualToAnchor:self.view.bottomAnchor
                                      constant:-32]
    ]];
}


#pragma mark - Color Input Delegate

- (void)colorInputViewDidChange:(ColorInputView *)inputView {

    NSString *value =
        inputView.textField.stringValue;


    CBColor *color =
        [CBColor colorFromString:value
                          format:self.currentFormat];


    /*
     Mientras el usuario escribe un valor incompleto,
     simplemente esperamos.

     No mostramos errores mientras escribe.
    */

    if (!color) {

        /*
         Como ya no existen dos colores válidos,
         ocultamos la paleta.
        */

        [self.paletteView clear];

        return;
    }


    /*
     El valor es válido.

     Sincronizamos el ColorWell.
    */

    inputView.color =
        color;


    /*
     Si existía un error anterior, ya no aplica.
    */

    [inputView clearValidationError];


    /*
     Intentamos generar inmediatamente la paleta.
    */

    [self updatePaletteIfPossible];
}


- (void)colorInputViewColorWellDidChange:(ColorInputView *)inputView {

    CBColor *color =
        inputView.color;


    if (!color) {
        return;
    }


    /*
     El ColorWell siempre proporciona un color válido.
    */

    [inputView clearValidationError];


    /*
     Sincronizamos el valor textual con el formato activo.
    */

    inputView.textField.stringValue =
        [color stringForFormat:self.currentFormat];


    /*
     Recalculamos automáticamente la paleta.
    */

    [self updatePaletteIfPossible];


    /*
     Regresamos el foco al campo correspondiente.
    */

    [self.view.window
        makeFirstResponder:inputView.textField];
}


#pragma mark - Web Safe Color Picker Delegate

- (void)webSafeColorPicker:(WebSafeColorPickerView *)picker
            didSelectColor:(CBColor *)color {

    ColorInputView *targetInput;


    if (self.webSafeTargetControl.selectedSegment == 1) {

        targetInput =
            self.color2Input;

    } else {

        targetInput =
            self.color1Input;
    }


    /*
     Actualizamos el texto según el formato activo.
    */

    targetInput.textField.stringValue =
        [color stringForFormat:self.currentFormat];


    /*
     Actualizamos el ColorWell.
    */

    targetInput.color =
        color;


    /*
     La selección Web Safe siempre es válida.
    */

    [targetInput clearValidationError];


    /*
     Recalculamos inmediatamente la paleta.
    */

    [self updatePaletteIfPossible];


    /*
     Regresamos el foco al campo correspondiente.
    */

    [self.view.window
        makeFirstResponder:targetInput.textField];
}


#pragma mark - Actions

- (void)midpointsChanged:(NSStepper *)sender {

    /*
     Actualizamos el número mostrado.
    */

    self.midpointsField.integerValue =
        sender.integerValue;


    /*
     Como el número de colores intermedios cambió,
     regeneramos inmediatamente la paleta.
    */

    [self updatePaletteIfPossible];
}


- (void)formatChanged:(NSSegmentedControl *)sender {

    // =========================================================
    // Determine Formats
    // =========================================================

    CBColorFormat previousFormat =
        self.currentFormat;

    CBColorFormat newFormat;


    switch (sender.selectedSegment) {

        case 0:
            newFormat =
                CBColorFormatHex;
            break;

        case 1:
            newFormat =
                CBColorFormatRGB;
            break;

        case 2:
            newFormat =
                CBColorFormatRGBPercent;
            break;

        default:
            newFormat =
                CBColorFormatHex;
            break;
    }


    if (newFormat == previousFormat) {
        return;
    }


    // =========================================================
    // Clear Validation
    // =========================================================

    [self.color1Input clearValidationError];
    [self.color2Input clearValidationError];


    // =========================================================
    // Parse Existing Values
    // =========================================================

    /*
     Primero interpretamos los valores con el formato anterior.
    */

    CBColor *color1 =
        [CBColor colorFromString:
            self.color1Input.textField.stringValue
                          format:previousFormat];


    CBColor *color2 =
        [CBColor colorFromString:
            self.color2Input.textField.stringValue
                          format:previousFormat];


    // =========================================================
    // Update Format
    // =========================================================

    self.currentFormat =
        newFormat;


    // =========================================================
    // Convert Color 1
    // =========================================================

    if (color1) {

        self.color1Input.textField.stringValue =
            [color1 stringForFormat:newFormat];

        self.color1Input.color =
            color1;
    }


    // =========================================================
    // Convert Color 2
    // =========================================================

    if (color2) {

        self.color2Input.textField.stringValue =
            [color2 stringForFormat:newFormat];

        self.color2Input.color =
            color2;
    }


    // =========================================================
    // Update Palette Format
    // =========================================================

    /*
     Si la paleta ya existe, sus colores no cambian.
     Solo cambia su representación textual.
    */

    [self.paletteView
        updateFormat:newFormat];


    // =========================================================
    // Update Placeholders
    // =========================================================

    [self updatePlaceholders];


    // =========================================================
    // Ensure Palette State
    // =========================================================

    /*
     Si ambos colores continúan siendo válidos,
     dejamos la paleta sincronizada.

     Si alguno no lo es, se limpiará.
    */

    [self updatePaletteIfPossible];
}


- (void)clearColors:(id)sender {

    // =========================================================
    // Inputs
    // =========================================================

    self.color1Input.textField.stringValue =
        @"";

    self.color2Input.textField.stringValue =
        @"";


    // =========================================================
    // Validation
    // =========================================================

    [self.color1Input clearValidationError];
    [self.color2Input clearValidationError];


    // =========================================================
    // Previews
    // =========================================================

    self.color1Input.color =
        nil;

    self.color2Input.color =
        nil;


    // =========================================================
    // Midpoints
    // =========================================================

    self.midpointsStepper.integerValue =
        1;

    self.midpointsField.integerValue =
        1;


    // =========================================================
    // Palette
    // =========================================================

    [self.paletteView clear];


    // =========================================================
    // Focus
    // =========================================================

    [self.view.window
        makeFirstResponder:self.color1Input.textField];
}


#pragma mark - Palette

- (void)updatePaletteIfPossible {

    /*
     Este es ahora el único lugar encargado de generar
     automáticamente la paleta.

     Cualquier cambio relevante termina llamando a este método.
    */


    // =========================================================
    // Parse Color 1
    // =========================================================

    CBColor *color1 =
        [CBColor colorFromString:
            self.color1Input.textField.stringValue
                          format:self.currentFormat];


    // =========================================================
    // Parse Color 2
    // =========================================================

    CBColor *color2 =
        [CBColor colorFromString:
            self.color2Input.textField.stringValue
                          format:self.currentFormat];


    // =========================================================
    // Require Two Valid Colors
    // =========================================================

    if (!color1 || !color2) {

        /*
         Una paleta solo tiene sentido cuando existen
         dos colores válidos.
        */

        [self.paletteView clear];

        return;
    }


    // =========================================================
    // Synchronize Previews
    // =========================================================

    self.color1Input.color =
        color1;

    self.color2Input.color =
        color2;


    // =========================================================
    // Generate Palette
    // =========================================================

    NSArray<CBColor *> *palette =
        [ColorBlenderEngine
            blendFromColor:color1
                   toColor:color2
                midpoints:
                    self.midpointsStepper.integerValue];


    // =========================================================
    // Display Palette
    // =========================================================

    [self.paletteView
        displayColors:palette
               format:self.currentFormat];
}


#pragma mark - Helpers

- (void)updatePlaceholders {

    switch (self.currentFormat) {

        // =====================================================
        // HEX
        // =====================================================

        case CBColorFormatHex:

            self.color1Input.textField.placeholderString =
                @"#5B21B6";

            self.color2Input.textField.placeholderString =
                @"#FF5B00";

            break;


        // =====================================================
        // RGB
        // =====================================================

        case CBColorFormatRGB:

            self.color1Input.textField.placeholderString =
                @"rgb(91,33,182)";

            self.color2Input.textField.placeholderString =
                @"rgb(255,91,0)";

            break;


        // =====================================================
        // RGB Percentage
        // =====================================================

        case CBColorFormatRGBPercent:

            self.color1Input.textField.placeholderString =
                @"rgb(36%,13%,71%)";

            self.color2Input.textField.placeholderString =
                @"rgb(100%,36%,0%)";

            break;
    }
}

@end