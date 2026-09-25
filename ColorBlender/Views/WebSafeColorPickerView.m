#import "WebSafeColorPickerView.h"

@interface CBWebSafeColorButton : NSButton

@property (nonatomic, strong) CBColor *webSafeColor;

@end

@implementation CBWebSafeColorButton

- (void)resetCursorRects {
    [super resetCursorRects];

    [self addCursorRect:self.bounds
                 cursor:NSCursor.pointingHandCursor];
}

@end


@interface WebSafeColorPickerView ()

@property (nonatomic, strong) NSStackView *mainStack;

@end


@implementation WebSafeColorPickerView

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

    /*
     Main vertical stack.

     Cada arrangedSubview será una fila de colores.
    */

    self.mainStack =
        [[NSStackView alloc] initWithFrame:NSZeroRect];

    self.mainStack.orientation =
        NSUserInterfaceLayoutOrientationVertical;

    self.mainStack.alignment =
        NSLayoutAttributeLeading;

    self.mainStack.distribution =
        NSStackViewDistributionFill;

    self.mainStack.spacing = 3;

    self.mainStack.translatesAutoresizingMaskIntoConstraints = NO;

    [self addSubview:self.mainStack];


    /*
     Los seis niveles utilizados por los colores Web Safe:

     00  33  66  99  CC  FF

     equivalen a:

     0, 51, 102, 153, 204, 255
    */

    NSArray<NSNumber *> *components = @[
        @0,
        @51,
        @102,
        @153,
        @204,
        @255
    ];


    /*
     Conservamos los 216 colores:

     6 × 6 × 6 = 216

     pero los distribuimos en 18 filas × 12 columnas
     para aprovechar una columna lateral relativamente estrecha.
    */

    NSMutableArray<CBColor *> *colors =
        [NSMutableArray arrayWithCapacity:216];

    for (NSNumber *redValue in components) {
        for (NSNumber *greenValue in components) {
            for (NSNumber *blueValue in components) {

                CBColor *color =
                    [[CBColor alloc]
                        initWithRed:redValue.doubleValue
                             green:greenValue.doubleValue
                              blue:blueValue.doubleValue];

                [colors addObject:color];
            }
        }
    }


    NSInteger columns = 12;
    CGFloat swatchSize = 18.0;


    for (NSInteger startIndex = 0;
         startIndex < colors.count;
         startIndex += columns) {

        NSStackView *row =
            [[NSStackView alloc] initWithFrame:NSZeroRect];

        row.orientation =
            NSUserInterfaceLayoutOrientationHorizontal;

        row.alignment =
            NSLayoutAttributeCenterY;

        row.distribution =
            NSStackViewDistributionFill;

        row.spacing = 3;

        row.translatesAutoresizingMaskIntoConstraints = NO;


        for (NSInteger column = 0;
             column < columns;
             column++) {

            NSInteger colorIndex =
                startIndex + column;

            if (colorIndex >= colors.count) {
                break;
            }


            CBColor *color =
                colors[colorIndex];


            CBWebSafeColorButton *button =
                [[CBWebSafeColorButton alloc]
                    initWithFrame:NSZeroRect];

            button.webSafeColor = color;

            button.title = @"";

            button.target = self;

            button.action =
                @selector(colorButtonPressed:);

            /*
             Quitamos el bezel estándar porque el propio color
             constituye la superficie del botón.
            */

            button.bordered = NO;

            button.wantsLayer = YES;

            button.layer.backgroundColor =
                color.nsColor.CGColor;

            button.layer.cornerRadius = 3.0;

            button.layer.borderWidth = 0.5;

            button.layer.borderColor =
                NSColor.separatorColor.CGColor;


            /*
             Tooltip para poder conocer el valor sin seleccionarlo.
            */

            button.toolTip =
                [color stringForFormat:CBColorFormatHex];

            button.translatesAutoresizingMaskIntoConstraints = NO;


            /*
             IMPORTANTE:

             El ancho y alto son exactamente iguales.

             Esto evita el problema de las barras gigantes que
             aparecía con NSGridView.
            */

            [NSLayoutConstraint activateConstraints:@[
                [button.widthAnchor
                    constraintEqualToConstant:swatchSize],

                [button.heightAnchor
                    constraintEqualToConstant:swatchSize]
            ]];


            [row addArrangedSubview:button];
        }


        [self.mainStack addArrangedSubview:row];
    }


    /*
     El picker adopta exactamente el tamaño de su contenido.
     No intentamos estirar las filas hasta llenar el ancho.
    */

    [NSLayoutConstraint activateConstraints:@[
        [self.mainStack.topAnchor
            constraintEqualToAnchor:self.topAnchor],

        [self.mainStack.leadingAnchor
            constraintEqualToAnchor:self.leadingAnchor],

        [self.mainStack.trailingAnchor
            constraintLessThanOrEqualToAnchor:self.trailingAnchor],

        [self.mainStack.bottomAnchor
            constraintEqualToAnchor:self.bottomAnchor]
    ]];
}

#pragma mark - Actions

- (void)colorButtonPressed:(CBWebSafeColorButton *)sender {
    CBColor *color =
        sender.webSafeColor;

    if (!color) {
        return;
    }

    [self.delegate
        webSafeColorPicker:self
            didSelectColor:color];
}

@end