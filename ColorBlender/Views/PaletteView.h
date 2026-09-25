#import <Cocoa/Cocoa.h>
#import "CBColor.h"

NS_ASSUME_NONNULL_BEGIN

@interface PaletteView : NSView

@property (nonatomic, copy, readonly) NSArray<CBColor *> *colors;

- (void)displayColors:(NSArray<CBColor *> *)colors
               format:(CBColorFormat)format;

- (void)updateFormat:(CBColorFormat)format;

- (void)clear;

@end

NS_ASSUME_NONNULL_END