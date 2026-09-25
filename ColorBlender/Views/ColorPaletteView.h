#import <Cocoa/Cocoa.h>
#import "CBColor.h"

@class ColorPaletteView;

NS_ASSUME_NONNULL_BEGIN

@protocol ColorPaletteViewDelegate <NSObject>

- (void)colorPaletteView:(ColorPaletteView *)paletteView
          didSelectColor:(CBColor *)color;

@end


@interface ColorPaletteView : NSView

@property (nonatomic, weak, nullable)
    id<ColorPaletteViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END