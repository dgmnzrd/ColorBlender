#import "PaletteView.h"

#pragma mark - Palette Color Item

@interface CBPaletteItemView : NSView

@property (nonatomic, strong) CBColor *color;
@property (nonatomic, assign) CBColorFormat format;

@property (nonatomic, strong) NSView *swatchView;
@property (nonatomic, strong) NSTextField *valueLabel;

- (instancetype)initWithColor:(CBColor *)color
                       format:(CBColorFormat)format;

- (void)updateFormat:(CBColorFormat)format;

@end


@implementation CBPaletteItemView

#pragma mark - Initialization

- (instancetype)initWithColor:(CBColor *)color
                       format:(CBColorFormat)format {

    self = [super initWithFrame:NSZeroRect];

    if (self) {
        _color = color;
        _format = format;

        [self setupView];
    }

    return self;
}

#pragma mark - Setup

- (void)setupView {
    self.translatesAutoresizingMaskIntoConstraints = NO;


    // =========================================================
    // Swatch
    // =========================================================

    self.swatchView =
        [[NSView alloc] initWithFrame:NSZeroRect];

    self.swatchView.wantsLayer = YES;

    self.swatchView.layer.backgroundColor =
        self.color.nsColor.CGColor;

    self.swatchView.layer.cornerRadius = 6.0;

    self.swatchView.layer.borderWidth = 1.0;

    self.swatchView.layer.borderColor =
        NSColor.separatorColor.CGColor;

    self.swatchView.translatesAutoresizingMaskIntoConstraints = NO;


    // =========================================================
    // Value
    // =========================================================

    self.valueLabel =
        [NSTextField labelWithString:
            [self.color stringForFormat:self.format]];

    self.valueLabel.font =
        [NSFont monospacedSystemFontOfSize:10
                                   weight:NSFontWeightRegular];

    self.valueLabel.alignment =
        NSTextAlignmentCenter;

    self.valueLabel.textColor =
        NSColor.secondaryLabelColor;

    self.valueLabel.lineBreakMode =
        NSLineBreakByTruncatingTail;

    self.valueLabel.maximumNumberOfLines = 1;

    self.valueLabel.translatesAutoresizingMaskIntoConstraints = NO;


    /*
     MUY IMPORTANTE:

     El texto NO puede exigirle ancho al item.

     Cuando tenemos 10 midpoints hay 12 colores y necesitamos
     que cada item pueda comprimirse sin empujar la columna
     Web Safe Colors.
    */

    [self.valueLabel
        setContentCompressionResistancePriority:
            NSLayoutPriorityDefaultLow
        forOrientation:NSLayoutConstraintOrientationHorizontal];

    [self.valueLabel
        setContentHuggingPriority:
            NSLayoutPriorityDefaultLow
        forOrientation:NSLayoutConstraintOrientationHorizontal];


    [self
        setContentCompressionResistancePriority:
            NSLayoutPriorityDefaultLow
        forOrientation:NSLayoutConstraintOrientationHorizontal];


    // =========================================================
    // Add Subviews
    // =========================================================

    [self addSubview:self.swatchView];
    [self addSubview:self.valueLabel];


    // =========================================================
    // Layout
    // =========================================================

    [NSLayoutConstraint activateConstraints:@[

        /*
         El swatch ocupa TODO el espacio vertical disponible
         excepto la zona reservada para el valor.
        */

        [self.swatchView.topAnchor
            constraintEqualToAnchor:self.topAnchor],

        [self.swatchView.leadingAnchor
            constraintEqualToAnchor:self.leadingAnchor],

        [self.swatchView.trailingAnchor
            constraintEqualToAnchor:self.trailingAnchor],


        /*
         El valor siempre queda abajo.
        */

        [self.valueLabel.topAnchor
            constraintEqualToAnchor:self.swatchView.bottomAnchor
                           constant:7],

        [self.valueLabel.leadingAnchor
            constraintEqualToAnchor:self.leadingAnchor],

        [self.valueLabel.trailingAnchor
            constraintEqualToAnchor:self.trailingAnchor],

        [self.valueLabel.bottomAnchor
            constraintEqualToAnchor:self.bottomAnchor],


        /*
         Garantizamos que el swatch tenga una altura útil,
         pero NO le damos una altura fija.

         Puede crecer verticalmente con PaletteView.
        */

        [self.swatchView.heightAnchor
            constraintGreaterThanOrEqualToConstant:80]
    ]];
}

#pragma mark - Format

- (void)updateFormat:(CBColorFormat)format {
    self.format = format;

    self.valueLabel.stringValue =
        [self.color stringForFormat:format];
}

#pragma mark - Mouse

- (void)mouseDown:(NSEvent *)event {
    NSString *value =
        [self.color stringForFormat:self.format];

    NSPasteboard *pasteboard =
        [NSPasteboard generalPasteboard];

    [pasteboard clearContents];

    [pasteboard setString:value
                  forType:NSPasteboardTypeString];


    NSColor *originalColor =
        self.valueLabel.textColor;

    self.valueLabel.textColor =
        NSColor.controlAccentColor;


    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            (int64_t)(0.20 * NSEC_PER_SEC)),
        dispatch_get_main_queue(),
        ^{
            self.valueLabel.textColor =
                originalColor;
        }
    );
}

#pragma mark - Cursor

- (void)resetCursorRects {
    [super resetCursorRects];

    [self addCursorRect:self.bounds
                 cursor:NSCursor.pointingHandCursor];
}

@end


#pragma mark - Palette View

@interface PaletteView ()

@property (nonatomic, strong) NSTextField *titleLabel;
@property (nonatomic, strong) NSTextField *hintLabel;

@property (nonatomic, strong) NSStackView *paletteStack;

@property (nonatomic, copy, readwrite)
    NSArray<CBColor *> *colors;

@property (nonatomic, assign)
    CBColorFormat currentFormat;

@end


@implementation PaletteView

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
    self.translatesAutoresizingMaskIntoConstraints = NO;

    self.colors = @[];
    self.currentFormat = CBColorFormatHex;


    // =========================================================
    // Title
    // =========================================================

    self.titleLabel =
        [NSTextField labelWithString:@"Palette"];

    self.titleLabel.font =
        [NSFont systemFontOfSize:13
                          weight:NSFontWeightSemibold];

    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;


    // =========================================================
    // Hint
    // =========================================================

    self.hintLabel =
        [NSTextField labelWithString:
            @"Click a color to copy its value"];

    self.hintLabel.font =
        [NSFont systemFontOfSize:11
                          weight:NSFontWeightRegular];

    self.hintLabel.textColor =
        NSColor.secondaryLabelColor;

    self.hintLabel.translatesAutoresizingMaskIntoConstraints = NO;


    // =========================================================
    // Palette Stack
    // =========================================================

    self.paletteStack =
        [[NSStackView alloc] initWithFrame:NSZeroRect];

    self.paletteStack.orientation =
        NSUserInterfaceLayoutOrientationHorizontal;

    /*
     Fill hará que los items utilicen toda la altura.
    */

    self.paletteStack.alignment =
        NSLayoutAttributeTop;

    /*
     Todos los colores reciben exactamente el mismo ancho.

     3 colores  = grandes
     12 colores = pequeños

     Pero el ancho TOTAL de Palette jamás cambia.
    */

    self.paletteStack.distribution =
        NSStackViewDistributionFillEqually;

    self.paletteStack.spacing = 6;

    self.paletteStack.translatesAutoresizingMaskIntoConstraints = NO;


    /*
     La propia pila tampoco debe intentar expandir
     la columna izquierda.
    */

    [self.paletteStack
        setContentCompressionResistancePriority:
            NSLayoutPriorityDefaultLow
        forOrientation:NSLayoutConstraintOrientationHorizontal];


    // =========================================================
    // Add Subviews
    // =========================================================

    [self addSubview:self.titleLabel];
    [self addSubview:self.hintLabel];
    [self addSubview:self.paletteStack];


    // =========================================================
    // Layout
    // =========================================================

    [NSLayoutConstraint activateConstraints:@[

        [self.titleLabel.topAnchor
            constraintEqualToAnchor:self.topAnchor],

        [self.titleLabel.leadingAnchor
            constraintEqualToAnchor:self.leadingAnchor],


        [self.hintLabel.centerYAnchor
            constraintEqualToAnchor:self.titleLabel.centerYAnchor],

        [self.hintLabel.leadingAnchor
            constraintEqualToAnchor:self.titleLabel.trailingAnchor
                           constant:10],

        [self.hintLabel.trailingAnchor
            constraintLessThanOrEqualToAnchor:self.trailingAnchor],


        /*
         Palette empieza debajo del título.
        */

        [self.paletteStack.topAnchor
            constraintEqualToAnchor:self.titleLabel.bottomAnchor
                           constant:10],

        [self.paletteStack.leadingAnchor
            constraintEqualToAnchor:self.leadingAnchor],

        [self.paletteStack.trailingAnchor
            constraintEqualToAnchor:self.trailingAnchor],

        /*
         Ahora ocupa TODO el espacio vertical restante.
        */

        [self.paletteStack.bottomAnchor
            constraintEqualToAnchor:self.bottomAnchor]
    ]];


    /*
     Palette siempre existe.

     Esto evita cualquier salto cuando presionamos Blend.
    */

    self.hidden = NO;

    self.hintLabel.hidden = YES;
}

#pragma mark - Public API

- (void)displayColors:(NSArray<CBColor *> *)colors
               format:(CBColorFormat)format {

    self.colors = [colors copy];
    self.currentFormat = format;

    [self rebuildPalette];

    self.hintLabel.hidden =
        (self.colors.count == 0);
}

- (void)updateFormat:(CBColorFormat)format {
    self.currentFormat = format;

    for (NSView *view
         in self.paletteStack.arrangedSubviews) {

        if ([view
            isKindOfClass:[CBPaletteItemView class]]) {

            CBPaletteItemView *item =
                (CBPaletteItemView *)view;

            [item updateFormat:format];
        }
    }
}

- (void)clear {
    self.colors = @[];

    [self removePaletteItems];

    self.hintLabel.hidden = YES;
}

#pragma mark - Palette

- (void)rebuildPalette {
    [self removePaletteItems];

    for (CBColor *color in self.colors) {

        CBPaletteItemView *item =
            [[CBPaletteItemView alloc]
                initWithColor:color
                       format:self.currentFormat];

        /*
         Cada item puede comprimirse horizontalmente.
         Esto es fundamental con 10 midpoints.
        */

        [item
            setContentCompressionResistancePriority:
                NSLayoutPriorityDefaultLow
            forOrientation:
                NSLayoutConstraintOrientationHorizontal];

        [item
            setContentHuggingPriority:
                NSLayoutPriorityDefaultLow
            forOrientation:
                NSLayoutConstraintOrientationHorizontal];


        [self.paletteStack
            addArrangedSubview:item];
    }
}

- (void)removePaletteItems {
    NSArray<NSView *> *items =
        [self.paletteStack.arrangedSubviews copy];

    for (NSView *view in items) {

        [self.paletteStack
            removeArrangedSubview:view];

        [view removeFromSuperview];
    }
}

@end