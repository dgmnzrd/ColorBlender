#import "CBColor.h"

@implementation CBColor

- (instancetype)initWithRed:(CGFloat)red
                      green:(CGFloat)green
                       blue:(CGFloat)blue {
    self = [super init];

    if (self) {
        _red = red;
        _green = green;
        _blue = blue;
    }

    return self;
}

- (BOOL)valid {
    return self.red >= 0.0 &&
           self.red <= 255.0 &&
           self.green >= 0.0 &&
           self.green <= 255.0 &&
           self.blue >= 0.0 &&
           self.blue <= 255.0;
}

+ (nullable instancetype)colorFromString:(NSString *)string
                                  format:(CBColorFormat)format {

    if (string.length == 0) {
        return nil;
    }

    NSString *value = [[string uppercaseString]
        stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (format == CBColorFormatHex) {
        value = [value stringByReplacingOccurrencesOfString:@"#"
                                                 withString:@""];

        // Igual que el original: #FFF -> #FFFFFF
        if (value.length == 3) {
            unichar r = [value characterAtIndex:0];
            unichar g = [value characterAtIndex:1];
            unichar b = [value characterAtIndex:2];

            value = [NSString stringWithFormat:
                @"%C%C%C%C%C%C",
                r, r,
                g, g,
                b, b];
        }

        if (value.length != 6) {
            return nil;
        }

        unsigned int rgb = 0;

        NSScanner *scanner = [NSScanner scannerWithString:value];

        if (![scanner scanHexInt:&rgb] || !scanner.isAtEnd) {
            return nil;
        }

        CGFloat red = (rgb >> 16) & 0xFF;
        CGFloat green = (rgb >> 8) & 0xFF;
        CGFloat blue = rgb & 0xFF;

        return [[CBColor alloc] initWithRed:red
                                     green:green
                                      blue:blue];
    }

    value = [value stringByReplacingOccurrencesOfString:@"RGB("
                                             withString:@""];

    value = [value stringByReplacingOccurrencesOfString:@")"
                                             withString:@""];

    NSArray<NSString *> *components =
        [value componentsSeparatedByString:@","];

    if (components.count != 3) {
        return nil;
    }

    CGFloat values[3];

    for (NSInteger i = 0; i < 3; i++) {
        NSString *component =
            [components[i] stringByTrimmingCharactersInSet:
                [NSCharacterSet whitespaceCharacterSet]];

        NSScanner *scanner = [NSScanner scannerWithString:component];

        double number;

        if (![scanner scanDouble:&number]) {
            return nil;
        }

        if (format == CBColorFormatRGBPercent) {
            [scanner scanString:@"%" intoString:nil];

            if (!scanner.isAtEnd || number < 0.0 || number > 100.0) {
                return nil;
            }

            values[i] = number * 2.55;
        } else {
            if (!scanner.isAtEnd || number < 0.0 || number > 255.0) {
                return nil;
            }

            values[i] = number;
        }
    }

    CBColor *color = [[CBColor alloc]
        initWithRed:values[0]
              green:values[1]
               blue:values[2]];

    return color.valid ? color : nil;
}

- (NSString *)stringForFormat:(CBColorFormat)format {
    NSInteger r = lround(self.red);
    NSInteger g = lround(self.green);
    NSInteger b = lround(self.blue);

    switch (format) {
        case CBColorFormatHex:
            return [NSString stringWithFormat:
                @"#%02lX%02lX%02lX",
                (long)r,
                (long)g,
                (long)b];

        case CBColorFormatRGB:
            return [NSString stringWithFormat:
                @"rgb(%ld,%ld,%ld)",
                (long)r,
                (long)g,
                (long)b];

        case CBColorFormatRGBPercent:
            return [NSString stringWithFormat:
                @"rgb(%ld%%,%ld%%,%ld%%)",
                (long)lround(self.red / 2.55),
                (long)lround(self.green / 2.55),
                (long)lround(self.blue / 2.55)];
    }

    return @"";
}

- (NSColor *)nsColor {
    return [NSColor colorWithSRGBRed:self.red / 255.0
                               green:self.green / 255.0
                                blue:self.blue / 255.0
                               alpha:1.0];
}

@end