#import "ColorBlenderEngine.h"

@implementation ColorBlenderEngine

+ (NSArray<CBColor *> *)blendFromColor:(CBColor *)startColor
                               toColor:(CBColor *)endColor
                            midpoints:(NSInteger)midpoints {

    if (!startColor ||
        !endColor ||
        !startColor.valid ||
        !endColor.valid) {
        return @[];
    }

    if (midpoints < 1) {
        midpoints = 1;
    }

    if (midpoints > 10) {
        midpoints = 10;
    }

    NSInteger steps = midpoints + 1;

    CGFloat redStep =
        (endColor.red - startColor.red) / steps;

    CGFloat greenStep =
        (endColor.green - startColor.green) / steps;

    CGFloat blueStep =
        (endColor.blue - startColor.blue) / steps;

    NSMutableArray<CBColor *> *palette =
        [NSMutableArray arrayWithCapacity:midpoints + 2];

    [palette addObject:startColor];

    for (NSInteger i = 1; i < steps; i++) {
        CGFloat red =
            startColor.red + (redStep * i);

        CGFloat green =
            startColor.green + (greenStep * i);

        CGFloat blue =
            startColor.blue + (blueStep * i);

        CBColor *color =
            [[CBColor alloc] initWithRed:red
                                  green:green
                                   blue:blue];

        [palette addObject:color];
    }

    [palette addObject:endColor];

    return [palette copy];
}

@end