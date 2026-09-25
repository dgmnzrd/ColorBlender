#import "ColorPaletteView.h"

#pragma mark - Constants

static const CGFloat CBPaletteSwatchSize = 16.0;
static const CGFloat CBPaletteHorizontalSpacing = 4.0;
static const CGFloat CBPaletteVerticalSpacing = 4.0;
static const CGFloat CBPaletteCornerRadius = 4.0;


#pragma mark - Color Button

@interface CBPaletteColorButton : NSButton

@property (nonatomic, strong) CBColor *paletteColor;
@property (nonatomic, assign) BOOL paletteSelected;

@end


@implementation CBPaletteColorButton

- (instancetype)initWithFrame:(NSRect)frameRect {

    self = [super initWithFrame:frameRect];

    if (self) {

        self.bordered = NO;
        self.title = @"";

        self.wantsLayer = YES;

        self.layer.cornerRadius =
            CBPaletteCornerRadius;

        self.layer.masksToBounds =
            YES;

        self.translatesAutoresizingMaskIntoConstraints =
            NO;
    }

    return self;
}


- (void)setPaletteSelected:(BOOL)paletteSelected {

    _paletteSelected =
        paletteSelected;

    [self updateAppearance];
}


- (void)updateAppearance {

    if (!self.layer) {
        return;
    }


    if (self.paletteSelected) {

        self.layer.borderWidth =
            2.0;

        self.layer.borderColor =
            NSColor.controlAccentColor.CGColor;

    } else {

        /*
         A very subtle separator-colored border keeps extremely
         light swatches visible in both Light and Dark Mode.
        */

        self.layer.borderWidth =
            0.5;

        self.layer.borderColor =
            NSColor.separatorColor.CGColor;
    }
}


- (void)viewDidChangeEffectiveAppearance {

    [super viewDidChangeEffectiveAppearance];

    /*
     Dynamic system colors such as separatorColor and
     controlAccentColor need to be reapplied to CALayer
     when the system appearance changes.
    */

    [self updateAppearance];
}


- (void)resetCursorRects {

    [super resetCursorRects];

    [self addCursorRect:self.bounds
                 cursor:NSCursor.pointingHandCursor];
}

@end


#pragma mark - Color Palette View

@interface ColorPaletteView ()

@property (nonatomic, strong) NSStackView *mainStack;
@property (nonatomic, strong) CBPaletteColorButton *selectedButton;

@end


@implementation ColorPaletteView

#pragma mark - Initialization

- (instancetype)initWithFrame:(NSRect)frameRect {

    self = [super initWithFrame:frameRect];

    if (self) {
        [self setupView];
    }

    return self;
}


#pragma mark - Setup

- (void)setupView {

    self.translatesAutoresizingMaskIntoConstraints =
        NO;


    // =========================================================
    // Main Stack
    //
    // The palette is intentionally NOT stretched.
    //
    // Each swatch has its own fixed size and spacing so the
    // component feels like a native color selector instead of
    // a continuous web-style color table.
    // =========================================================

    self.mainStack =
        [[NSStackView alloc]
            initWithFrame:NSZeroRect];

    self.mainStack.orientation =
        NSUserInterfaceLayoutOrientationHorizontal;

    self.mainStack.alignment =
        NSLayoutAttributeTop;

    self.mainStack.distribution =
        NSStackViewDistributionFill;

    self.mainStack.spacing =
        CBPaletteHorizontalSpacing;

    self.mainStack.translatesAutoresizingMaskIntoConstraints =
        NO;

    [self addSubview:self.mainStack];


    // =========================================================
    // Palette Data
    //
    // 22 families × 11 shades = 242 colors
    //
    // Light shades are at the top.
    // Dark shades are at the bottom.
    // =========================================================

    NSArray<NSArray<NSArray<NSNumber *> *> *> *palette = @[

        // Red
        @[
            @[@254,@242,@242],
            @[@255,@226,@226],
            @[@255,@201,@201],
            @[@255,@162,@162],
            @[@255,@100,@103],
            @[@251,@44,@54],
            @[@231,@24,@11],
            @[@193,@16,@7],
            @[@159,@7,@18],
            @[@130,@24,@26],
            @[@70,@8,@9]
        ],

        // Orange
        @[
            @[@255,@247,@237],
            @[@255,@237,@212],
            @[@255,@214,@167],
            @[@255,@184,@106],
            @[@255,@137,@4],
            @[@255,@105,@42],
            @[@245,@73,@39],
            @[@202,@53,@25],
            @[@159,@45,@1],
            @[@126,@42,@12],
            @[@68,@19,@6]
        ],

        // Amber
        @[
            @[@255,@251,@235],
            @[@254,@243,@198],
            @[@254,@230,@133],
            @[@255,@210,@48],
            @[@255,@185,@59],
            @[@254,@154,@55],
            @[@225,@113,@43],
            @[@187,@77,@26],
            @[@151,@60,@8],
            @[@123,@51,@6],
            @[@70,@25,@1]
        ],

        // Yellow
        @[
            @[@254,@252,@232],
            @[@254,@249,@194],
            @[@255,@240,@133],
            @[@255,@223,@32],
            @[@253,@199,@69],
            @[@240,@177,@59],
            @[@208,@135,@46],
            @[@166,@95,@27],
            @[@137,@75,@10],
            @[@115,@62,@10],
            @[@67,@32,@4]
        ],

        // Lime
        @[
            @[@247,@254,@231],
            @[@236,@252,@202],
            @[@216,@249,@153],
            @[@187,@244,@81],
            @[@154,@230,@48],
            @[@124,@207,@53],
            @[@94,@165,@41],
            @[@73,@125,@21],
            @[@60,@99,@1],
            @[@53,@83,@14],
            @[@25,@46,@3]
        ],

        // Green
        @[
            @[@240,@253,@244],
            @[@220,@252,@231],
            @[@185,@248,@207],
            @[@123,@241,@168],
            @[@5,@223,@114],
            @[@49,@201,@80],
            @[@42,@166,@62],
            @[@23,@130,@54],
            @[@1,@102,@48],
            @[@13,@84,@43],
            @[@3,@46,@21]
        ],

        // Emerald
        @[
            @[@236,@253,@245],
            @[@208,@250,@229],
            @[@164,@244,@207],
            @[@94,@233,@181],
            @[@49,@212,@146],
            @[@55,@188,@125],
            @[@45,@153,@102],
            @[@31,@122,@85],
            @[@17,@96,@69],
            @[@3,@79,@59],
            @[@1,@44,@34]
        ],

        // Teal
        @[
            @[@240,@253,@250],
            @[@203,@251,@241],
            @[@150,@247,@228],
            @[@70,@236,@213],
            @[@56,@213,@190],
            @[@54,@187,@167],
            @[@42,@150,@137],
            @[@24,@120,@111],
            @[@7,@95,@90],
            @[@11,@79,@74],
            @[@2,@47,@46]
        ],

        // Cyan
        @[
            @[@236,@254,@255],
            @[@206,@250,@254],
            @[@162,@244,@253],
            @[@83,@234,@253],
            @[@66,@211,@242],
            @[@59,@184,@219],
            @[@44,@146,@184],
            @[@26,@117,@149],
            @[@1,@95,@120],
            @[@16,@78,@100],
            @[@5,@51,@69]
        ],

        // Sky
        @[
            @[@240,@249,@255],
            @[@223,@242,@254],
            @[@184,@230,@254],
            @[@116,@212,@255],
            @[@33,@188,@255],
            @[@52,@166,@244],
            @[@41,@132,@209],
            @[@28,@105,@168],
            @[@16,@89,@138],
            @[@2,@74,@112],
            @[@5,@47,@74]
        ],

        // Blue
        @[
            @[@239,@246,@255],
            @[@219,@234,@254],
            @[@190,@219,@255],
            @[@142,@197,@255],
            @[@81,@162,@255],
            @[@43,@127,@255],
            @[@21,@93,@252],
            @[@20,@71,@230],
            @[@25,@60,@184],
            @[@28,@57,@142],
            @[@22,@36,@86]
        ],

        // Indigo
        @[
            @[@238,@242,@255],
            @[@224,@231,@255],
            @[@198,@210,@255],
            @[@163,@179,@255],
            @[@124,@134,@255],
            @[@97,@95,@255],
            @[@79,@57,@246],
            @[@67,@45,@215],
            @[@55,@42,@172],
            @[@49,@44,@133],
            @[@30,@26,@77]
        ],

        // Violet
        @[
            @[@245,@243,@255],
            @[@237,@233,@254],
            @[@221,@214,@255],
            @[@196,@180,@255],
            @[@166,@132,@255],
            @[@142,@81,@255],
            @[@127,@34,@254],
            @[@112,@8,@231],
            @[@93,@14,@192],
            @[@77,@23,@154],
            @[@47,@13,@104]
        ],

        // Purple
        @[
            @[@250,@245,@255],
            @[@243,@232,@255],
            @[@233,@212,@255],
            @[@218,@178,@255],
            @[@194,@122,@255],
            @[@173,@70,@255],
            @[@152,@16,@250],
            @[@130,@7,@219],
            @[@110,@17,@176],
            @[@89,@22,@139],
            @[@60,@3,@102]
        ],

        // Fuchsia
        @[
            @[@253,@244,@255],
            @[@250,@232,@255],
            @[@246,@207,@255],
            @[@244,@168,@255],
            @[@237,@106,@255],
            @[@225,@42,@251],
            @[@200,@28,@222],
            @[@168,@19,@183],
            @[@138,@1,@148],
            @[@114,@19,@120],
            @[@75,@0,@79]
        ],

        // Pink
        @[
            @[@253,@242,@248],
            @[@252,@231,@243],
            @[@252,@206,@232],
            @[@253,@165,@213],
            @[@251,@100,@182],
            @[@246,@51,@154],
            @[@230,@24,@118],
            @[@198,@24,@92],
            @[@163,@4,@76],
            @[@134,@16,@67],
            @[@81,@4,@36]
        ],

        // Rose
        @[
            @[@255,@241,@242],
            @[@255,@228,@230],
            @[@255,@204,@211],
            @[@255,@161,@173],
            @[@255,@99,@126],
            @[@255,@32,@86],
            @[@236,@37,@63],
            @[@199,@29,@54],
            @[@165,@12,@54],
            @[@139,@8,@54],
            @[@77,@2,@24]
        ],

        // Slate
        @[
            @[@248,@250,@252],
            @[@241,@245,@249],
            @[@226,@232,@240],
            @[@202,@213,@226],
            @[@144,@161,@185],
            @[@98,@116,@142],
            @[@69,@85,@108],
            @[@49,@65,@88],
            @[@29,@41,@61],
            @[@15,@23,@43],
            @[@2,@6,@24]
        ],

        // Gray
        @[
            @[@249,@250,@251],
            @[@243,@244,@246],
            @[@229,@231,@235],
            @[@209,@213,@220],
            @[@153,@161,@175],
            @[@106,@114,@130],
            @[@74,@85,@101],
            @[@54,@65,@83],
            @[@30,@41,@57],
            @[@16,@24,@40],
            @[@3,@7,@18]
        ],

        // Zinc
        @[
            @[@250,@250,@250],
            @[@244,@244,@245],
            @[@228,@228,@231],
            @[@212,@212,@216],
            @[@159,@159,@169],
            @[@113,@113,@123],
            @[@82,@82,@92],
            @[@63,@63,@70],
            @[@39,@39,@42],
            @[@24,@24,@27],
            @[@9,@9,@11]
        ],

        // Neutral
        @[
            @[@250,@250,@250],
            @[@245,@245,@245],
            @[@229,@229,@229],
            @[@212,@212,@212],
            @[@161,@161,@161],
            @[@115,@115,@115],
            @[@82,@82,@82],
            @[@64,@64,@64],
            @[@38,@38,@38],
            @[@23,@23,@23],
            @[@10,@10,@10]
        ],

        // Stone
        @[
            @[@250,@250,@249],
            @[@245,@245,@244],
            @[@231,@229,@228],
            @[@214,@211,@209],
            @[@166,@160,@155],
            @[@121,@113,@107],
            @[@87,@83,@77],
            @[@68,@64,@59],
            @[@41,@37,@36],
            @[@28,@25,@23],
            @[@12,@10,@9]
        ]
    ];


    // =========================================================
    // Build Columns
    // =========================================================

    for (NSArray<NSArray<NSNumber *> *> *family in palette) {

        NSStackView *column =
            [[NSStackView alloc]
                initWithFrame:NSZeroRect];

        column.orientation =
            NSUserInterfaceLayoutOrientationVertical;

        column.alignment =
            NSLayoutAttributeCenterX;

        column.distribution =
            NSStackViewDistributionFill;

        column.spacing =
            CBPaletteVerticalSpacing;

        column.translatesAutoresizingMaskIntoConstraints =
            NO;


        for (NSArray<NSNumber *> *rgb in family) {

            CGFloat red =
                rgb[0].doubleValue;

            CGFloat green =
                rgb[1].doubleValue;

            CGFloat blue =
                rgb[2].doubleValue;


            CBColor *color =
                [[CBColor alloc]
                    initWithRed:red
                         green:green
                          blue:blue];


            CBPaletteColorButton *button =
                [[CBPaletteColorButton alloc]
                    initWithFrame:NSZeroRect];

            button.paletteColor =
                color;

            button.target =
                self;

            button.action =
                @selector(colorButtonPressed:);


            /*
             The swatch itself is now a compact independent
             control rather than a cell in a continuous table.
            */

            button.layer.backgroundColor =
                color.nsColor.CGColor;

            button.paletteSelected =
                NO;


            /*
             HEX remains available without adding visual noise.
            */

            button.toolTip =
                [color stringForFormat:CBColorFormatHex];


            [NSLayoutConstraint activateConstraints:@[

                [button.widthAnchor
                    constraintEqualToConstant:
                        CBPaletteSwatchSize],

                [button.heightAnchor
                    constraintEqualToConstant:
                        CBPaletteSwatchSize]
            ]];


            [column addArrangedSubview:button];
        }


        [self.mainStack addArrangedSubview:column];
    }


    // =========================================================
    // Layout
    //
    // The palette is centered instead of stretching from one
    // edge of the right column to the other.
    // =========================================================

    [NSLayoutConstraint activateConstraints:@[

        [self.mainStack.topAnchor
            constraintEqualToAnchor:self.topAnchor],

        [self.mainStack.centerXAnchor
            constraintEqualToAnchor:self.centerXAnchor],

        [self.mainStack.leadingAnchor
            constraintGreaterThanOrEqualToAnchor:self.leadingAnchor],

        [self.mainStack.trailingAnchor
            constraintLessThanOrEqualToAnchor:self.trailingAnchor],

        [self.bottomAnchor
            constraintEqualToAnchor:self.mainStack.bottomAnchor]
    ]];
}


#pragma mark - Actions

- (void)colorButtonPressed:(CBPaletteColorButton *)sender {

    CBColor *color =
        sender.paletteColor;


    if (!color) {
        return;
    }


    // =========================================================
    // Selection Feedback
    // =========================================================

    if (self.selectedButton &&
        self.selectedButton != sender) {

        self.selectedButton.paletteSelected =
            NO;
    }


    self.selectedButton =
        sender;

    sender.paletteSelected =
        YES;


    // =========================================================
    // Notify Controller
    // =========================================================

    [self.delegate
        colorPaletteView:self
          didSelectColor:color];
}

@end