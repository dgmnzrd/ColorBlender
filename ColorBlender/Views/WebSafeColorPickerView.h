#import <Cocoa/Cocoa.h>
#import "CBColor.h"

@class WebSafeColorPickerView;

NS_ASSUME_NONNULL_BEGIN

@protocol WebSafeColorPickerViewDelegate <NSObject>

- (void)webSafeColorPicker:(WebSafeColorPickerView *)picker
            didSelectColor:(CBColor *)color;

@end

@interface WebSafeColorPickerView : NSView

@property (nonatomic, weak, nullable)
    id<WebSafeColorPickerViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END