#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CBColorFormat) {
    CBColorFormatHex,
    CBColorFormatRGB,
    CBColorFormatRGBPercent
};

@interface CBColor : NSObject

@property (nonatomic, assign) CGFloat red;
@property (nonatomic, assign) CGFloat green;
@property (nonatomic, assign) CGFloat blue;

@property (nonatomic, assign, readonly) BOOL valid;

- (instancetype)initWithRed:(CGFloat)red
                      green:(CGFloat)green
                       blue:(CGFloat)blue;

+ (nullable instancetype)colorFromString:(NSString *)string
                                  format:(CBColorFormat)format;

- (NSString *)stringForFormat:(CBColorFormat)format;

- (NSColor *)nsColor;

@end

NS_ASSUME_NONNULL_END