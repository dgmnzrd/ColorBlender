#import <XCTest/XCTest.h>

#import "CBColor.h"
#import "ColorBlenderEngine.h"

@interface ColorBlenderEngineTests : XCTestCase

@end

@implementation ColorBlenderEngineTests

- (void)testRedToBlueWithThreeMidpoints {
    CBColor *red =
        [CBColor colorFromString:@"#FF0000"
                          format:CBColorFormatHex];

    CBColor *blue =
        [CBColor colorFromString:@"#0000FF"
                          format:CBColorFormatHex];

    NSArray<CBColor *> *palette =
        [ColorBlenderEngine blendFromColor:red
                                   toColor:blue
                                midpoints:3];

    XCTAssertEqual(palette.count, 5);

    XCTAssertEqualObjects(
        [palette.firstObject stringForFormat:CBColorFormatHex],
        @"#FF0000"
    );

    XCTAssertEqualObjects(
        [palette.lastObject stringForFormat:CBColorFormatHex],
        @"#0000FF"
    );
}

@end