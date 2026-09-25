#import <Foundation/Foundation.h>
#import "CBColor.h"

NS_ASSUME_NONNULL_BEGIN

@interface ColorBlenderEngine : NSObject

+ (NSArray<CBColor *> *)blendFromColor:(CBColor *)startColor
                               toColor:(CBColor *)endColor
                            midpoints:(NSInteger)midpoints;

@end

NS_ASSUME_NONNULL_END