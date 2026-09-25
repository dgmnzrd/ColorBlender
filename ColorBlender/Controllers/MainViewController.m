#import "MainViewController.h"

#import "CBColor.h"
#import "ColorBlenderEngine.h"
#import "ColorInputView.h"
#import "PaletteView.h"
#import "ColorPaletteView.h"

@interface MainViewController ()
    <ColorInputViewDelegate,
     ColorPaletteViewDelegate>

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

@property (nonatomic, strong) NSTextField *colorPaletteTitleLabel;
@property (nonatomic, strong) NSTextField *colorPaletteSubtitleLabel;

@property (nonatomic, strong)
    NSSegmentedControl *colorPaletteTargetControl;

@property (nonatomic, strong)
    ColorPaletteView *colorPaletteView;

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
    // Generated Palette
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
    // Color Palette
    // =========================================================

    self.colorPaletteTitleLabel =
        [NSTextField labelWithString:@"Color Palette"];

    self.colorPaletteTitleLabel.font =
        [NSFont systemFontOfSize:13
                          weight:NSFontWeightSemibold];

    self.colorPaletteTitleLabel.translatesAutoresizingMaskIntoConstraints =
        NO;


    self.colorPaletteSubtitleLabel =
        [NSTextField labelWithString:
            @"Select a target, then choose a color."];

    self.colorPaletteSubtitleLabel.font =
        [NSFont systemFontOfSize:11
                          weight:NSFontWeightRegular];

    self.colorPaletteSubtitleLabel.textColor =
        NSColor.secondaryLabelColor;

    self.colorPaletteSubtitleLabel.translatesAutoresizingMaskIntoConstraints =
        NO;


    self.colorPaletteTargetControl =
        [NSSegmentedControl
            segmentedControlWithLabels:@[
                @"Color 1",
                @"Color 2"
            ]
            trackingMode:NSSegmentSwitchTrackingSelectOne
            target:nil
            action:nil];

    self.colorPaletteTargetControl.selectedSegment =
        0;

    self.colorPaletteTargetControl.translatesAutoresizingMaskIntoConstraints =
        NO;


    self.colorPaletteView =
        [[ColorPaletteView alloc]
            initWithFrame:NSZeroRect];

    self.colorPaletteView.delegate =
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

    [self.view addSubview:self.colorPaletteTitleLabel];
    [self.view addSubview:self.colorPaletteSubtitleLabel];
    [self.view addSubview:self.colorPaletteTargetControl];
    [self.view addSubview:self.colorPaletteView];


    // =========================================================
    // Layout
    // =========================================================

    [NSLayoutConstraint activateConstraints:@[

        // Header

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


        // Vertical Separator

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


        // Color 1

        [self.color1Input.topAnchor
            constraintEqualToAnchor:self.subtitleLabel.bottomAnchor
                           constant:32],

        [self.color1Input.leadingAnchor
            constraintEqualToAnchor:self.view.leadingAnchor
                           constant:32],

        [self.color1Input.trailingAnchor
            constraintEqualToAnchor:self.verticalSeparator.leadingAnchor
                           constant:-24],


        // Color 2

        [self.color2Input.topAnchor
            constraintEqualToAnchor:self.color1Input.bottomAnchor
                           constant:20],

        [self.color2Input.leadingAnchor
            constraintEqualToAnchor:self.color1Input.leadingAnchor],

        [self.color2Input.trailingAnchor
            constraintEqualToAnchor:self.color1Input.trailingAnchor],


        // Format

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


        // Midpoints

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


        // Clear

        [self.clearButton.leadingAnchor
            constraintEqualToAnchor:self.midpointsStepper.trailingAnchor
                           constant:24],

        [self.clearButton.centerYAnchor
            constraintEqualToAnchor:self.formatControl.centerYAnchor],

        [self.clearButton.trailingAnchor
            constraintLessThanOrEqualToAnchor:self.color1Input.trailingAnchor],


        // Generated Palette

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


        // Color Palette Title

        [self.colorPaletteTitleLabel.topAnchor
            constraintEqualToAnchor:self.color1Input.topAnchor],

        [self.colorPaletteTitleLabel.leadingAnchor
            constraintEqualToAnchor:self.verticalSeparator.trailingAnchor
                           constant:24],

        [self.colorPaletteTitleLabel.trailingAnchor
            constraintLessThanOrEqualToAnchor:self.view.trailingAnchor
                                      constant:-24],


        // Color Palette Subtitle

        [self.colorPaletteSubtitleLabel.topAnchor
            constraintEqualToAnchor:self.colorPaletteTitleLabel.bottomAnchor
                           constant:4],

        [self.colorPaletteSubtitleLabel.leadingAnchor
            constraintEqualToAnchor:self.colorPaletteTitleLabel.leadingAnchor],

        [self.colorPaletteSubtitleLabel.trailingAnchor
            constraintLessThanOrEqualToAnchor:self.view.trailingAnchor
                                      constant:-24],


        // Target

        [self.colorPaletteTargetControl.topAnchor
            constraintEqualToAnchor:self.colorPaletteSubtitleLabel.bottomAnchor
                           constant:12],

        [self.colorPaletteTargetControl.leadingAnchor
            constraintEqualToAnchor:self.colorPaletteTitleLabel.leadingAnchor],

        [self.colorPaletteTargetControl.trailingAnchor
            constraintEqualToAnchor:self.view.trailingAnchor
                           constant:-24],


        // Modern Color Palette

        [self.colorPaletteView.topAnchor
            constraintEqualToAnchor:self.colorPaletteTargetControl.bottomAnchor
                           constant:14],

        [self.colorPaletteView.leadingAnchor
            constraintEqualToAnchor:self.colorPaletteTitleLabel.leadingAnchor],

        [self.colorPaletteView.trailingAnchor
            constraintEqualToAnchor:self.view.trailingAnchor
                           constant:-24],

        [self.colorPaletteView.bottomAnchor
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


    if (!color) {

        [self.paletteView clear];

        return;
    }


    inputView.color =
        color;

    [inputView clearValidationError];

    [self updatePaletteIfPossible];
}


- (void)colorInputViewColorWellDidChange:(ColorInputView *)inputView {

    CBColor *color =
        inputView.color;


    if (!color) {
        return;
    }


    [inputView clearValidationError];


    inputView.textField.stringValue =
        [color stringForFormat:self.currentFormat];


    [self updatePaletteIfPossible];


    [self.view.window
        makeFirstResponder:inputView.textField];
}


#pragma mark - Color Palette Delegate

- (void)colorPaletteView:(ColorPaletteView *)paletteView
          didSelectColor:(CBColor *)color {

    ColorInputView *targetInput;


    if (self.colorPaletteTargetControl.selectedSegment == 1) {

        targetInput =
            self.color2Input;

    } else {

        targetInput =
            self.color1Input;
    }


    targetInput.textField.stringValue =
        [color stringForFormat:self.currentFormat];


    targetInput.color =
        color;


    [targetInput clearValidationError];


    /*
     1.1.0 Live Palette integration.

     Selecting a color from the modern palette immediately
     updates the generated blend when both endpoints are valid.
    */

    [self updatePaletteIfPossible];


    [self.view.window
        makeFirstResponder:targetInput.textField];
}


#pragma mark - Actions

- (void)midpointsChanged:(NSStepper *)sender {

    self.midpointsField.integerValue =
        sender.integerValue;


    [self updatePaletteIfPossible];
}


- (void)formatChanged:(NSSegmentedControl *)sender {

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


    [self.color1Input clearValidationError];
    [self.color2Input clearValidationError];


    CBColor *color1 =
        [CBColor colorFromString:
            self.color1Input.textField.stringValue
                          format:previousFormat];


    CBColor *color2 =
        [CBColor colorFromString:
            self.color2Input.textField.stringValue
                          format:previousFormat];


    self.currentFormat =
        newFormat;


    if (color1) {

        self.color1Input.textField.stringValue =
            [color1 stringForFormat:newFormat];

        self.color1Input.color =
            color1;
    }


    if (color2) {

        self.color2Input.textField.stringValue =
            [color2 stringForFormat:newFormat];

        self.color2Input.color =
            color2;
    }


    [self.paletteView
        updateFormat:newFormat];


    [self updatePlaceholders];


    [self updatePaletteIfPossible];
}


- (void)clearColors:(id)sender {

    self.color1Input.textField.stringValue =
        @"";

    self.color2Input.textField.stringValue =
        @"";


    [self.color1Input clearValidationError];
    [self.color2Input clearValidationError];


    self.color1Input.color =
        nil;

    self.color2Input.color =
        nil;


    self.midpointsStepper.integerValue =
        1;

    self.midpointsField.integerValue =
        1;


    [self.paletteView clear];


    [self.view.window
        makeFirstResponder:self.color1Input.textField];
}


#pragma mark - Generated Palette

- (void)updatePaletteIfPossible {

    CBColor *color1 =
        [CBColor colorFromString:
            self.color1Input.textField.stringValue
                          format:self.currentFormat];


    CBColor *color2 =
        [CBColor colorFromString:
            self.color2Input.textField.stringValue
                          format:self.currentFormat];


    if (!color1 || !color2) {

        [self.paletteView clear];

        return;
    }


    self.color1Input.color =
        color1;

    self.color2Input.color =
        color2;


    NSArray<CBColor *> *palette =
        [ColorBlenderEngine
            blendFromColor:color1
                   toColor:color2
                midpoints:
                    self.midpointsStepper.integerValue];


    [self.paletteView
        displayColors:palette
               format:self.currentFormat];
}


#pragma mark - Helpers

- (void)updatePlaceholders {

    switch (self.currentFormat) {

        case CBColorFormatHex:

            self.color1Input.textField.placeholderString =
                @"#5B21B6";

            self.color2Input.textField.placeholderString =
                @"#FF5B00";

            break;


        case CBColorFormatRGB:

            self.color1Input.textField.placeholderString =
                @"rgb(91,33,182)";

            self.color2Input.textField.placeholderString =
                @"rgb(255,91,0)";

            break;


        case CBColorFormatRGBPercent:

            self.color1Input.textField.placeholderString =
                @"rgb(36%,13%,71%)";

            self.color2Input.textField.placeholderString =
                @"rgb(100%,36%,0%)";

            break;
    }
}

@end