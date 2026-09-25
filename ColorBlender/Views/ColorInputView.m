#import "ColorInputView.h"
#import "CBColor.h"

@interface ColorInputView ()

@property (nonatomic, strong) NSTextField *titleLabel;

@property (nonatomic, readwrite, strong) NSTextField *textField;
@property (nonatomic, readwrite, strong) NSColorWell *colorWell;

@property (nonatomic, strong) NSTextField *validationLabel;

@end


@implementation ColorInputView

#pragma mark - Initialization

- (instancetype)initWithTitle:(NSString *)title {
    self = [super initWithFrame:NSZeroRect];

    if (self) {
        [self setupViewWithTitle:title];
    }

    return self;
}

#pragma mark - Setup

- (void)setupViewWithTitle:(NSString *)title {

    self.translatesAutoresizingMaskIntoConstraints = NO;


    // =========================================================
    // Title
    // =========================================================

    self.titleLabel =
        [NSTextField labelWithString:title];

    self.titleLabel.font =
        [NSFont systemFontOfSize:13
                          weight:NSFontWeightSemibold];

    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;


    // =========================================================
    // Color Well
    // =========================================================

    self.colorWell =
        [[NSColorWell alloc] initWithFrame:NSZeroRect];

    self.colorWell.target = self;
    self.colorWell.action =
        @selector(colorWellChanged:);

    self.colorWell.translatesAutoresizingMaskIntoConstraints = NO;


    // =========================================================
    // Text Field
    // =========================================================

    self.textField =
        [[NSTextField alloc] initWithFrame:NSZeroRect];

    self.textField.translatesAutoresizingMaskIntoConstraints = NO;

    self.textField.font =
        [NSFont monospacedSystemFontOfSize:13
                                   weight:NSFontWeightRegular];

    self.textField.placeholderString = @"#000000";

    self.textField.delegate = self;


    // =========================================================
    // Validation Label
    // =========================================================

    self.validationLabel =
        [NSTextField labelWithString:@""];

    self.validationLabel.font =
        [NSFont systemFontOfSize:11
                          weight:NSFontWeightRegular];

    self.validationLabel.textColor =
        NSColor.systemRedColor;

    self.validationLabel.hidden = YES;

    self.validationLabel.translatesAutoresizingMaskIntoConstraints = NO;


    // =========================================================
    // Add Subviews
    // =========================================================

    [self addSubview:self.titleLabel];
    [self addSubview:self.colorWell];
    [self addSubview:self.textField];
    [self addSubview:self.validationLabel];


    // =========================================================
    // Layout
    // =========================================================

    [NSLayoutConstraint activateConstraints:@[

        // Title

        [self.titleLabel.topAnchor
            constraintEqualToAnchor:self.topAnchor],

        [self.titleLabel.leadingAnchor
            constraintEqualToAnchor:self.leadingAnchor],


        // Color Well

        [self.colorWell.topAnchor
            constraintEqualToAnchor:self.titleLabel.bottomAnchor
                           constant:8],

        [self.colorWell.leadingAnchor
            constraintEqualToAnchor:self.leadingAnchor],

        [self.colorWell.widthAnchor
            constraintEqualToConstant:44],

        [self.colorWell.heightAnchor
            constraintEqualToConstant:28],


        // Text Field

        [self.textField.leadingAnchor
            constraintEqualToAnchor:self.colorWell.trailingAnchor
                           constant:10],

        [self.textField.trailingAnchor
            constraintEqualToAnchor:self.trailingAnchor],

        [self.textField.centerYAnchor
            constraintEqualToAnchor:self.colorWell.centerYAnchor],

        [self.textField.heightAnchor
            constraintEqualToConstant:28],


        // Validation Label

        [self.validationLabel.topAnchor
            constraintEqualToAnchor:self.textField.bottomAnchor
                           constant:4],

        [self.validationLabel.leadingAnchor
            constraintEqualToAnchor:self.textField.leadingAnchor],

        [self.validationLabel.trailingAnchor
            constraintLessThanOrEqualToAnchor:self.trailingAnchor],

        [self.validationLabel.bottomAnchor
            constraintEqualToAnchor:self.bottomAnchor]
    ]];
}

#pragma mark - Text Field Delegate

- (void)controlTextDidChange:(NSNotification *)notification {

    if (notification.object != self.textField) {
        return;
    }


    /*
     Si el usuario comienza a corregir el valor, quitamos
     inmediatamente el error anterior.

     No mostramos un nuevo error mientras está escribiendo.
    */

    [self clearValidationError];


    /*
     Informamos al controller para que pueda actualizar
     el preview cuando el valor llegue a ser válido.
    */

    [self.delegate
        colorInputViewDidChange:self];
}

#pragma mark - Color Well

- (void)colorWellChanged:(NSColorWell *)sender {

    NSColor *selectedColor =
        [sender.color
            colorUsingColorSpace:
                NSColorSpace.sRGBColorSpace];


    if (!selectedColor) {
        return;
    }


    /*
     NSColor utiliza componentes entre 0 y 1.

     CBColor trabaja internamente con valores entre 0 y 255.
    */

    CBColor *color =
        [[CBColor alloc]
            initWithRed:selectedColor.redComponent * 255.0
                  green:selectedColor.greenComponent * 255.0
                   blue:selectedColor.blueComponent * 255.0];


    self.color = color;


    /*
     Una selección realizada mediante el selector nativo
     siempre representa un color válido.
    */

    [self clearValidationError];


    /*
     El controller actualizará la representación textual
     según HEX, RGB o RGB%.
    */

    [self.delegate
        colorInputViewColorWellDidChange:self];
}

#pragma mark - Color

- (void)setColor:(CBColor * _Nullable)color {

    _color = color;


    if (color) {

        self.colorWell.color =
            color.nsColor;

    } else {

        /*
         Cuando no existe un color utilizamos un color
         semántico del sistema para conservar compatibilidad
         automática con Light y Dark Mode.
        */

        self.colorWell.color =
            NSColor.controlBackgroundColor;
    }
}

#pragma mark - Validation

- (void)showValidationError:(NSString *)message {

    self.validationLabel.stringValue =
        message;

    self.validationLabel.hidden =
        NO;
}


- (void)clearValidationError {

    self.validationLabel.stringValue =
        @"";

    self.validationLabel.hidden =
        YES;
}

@end