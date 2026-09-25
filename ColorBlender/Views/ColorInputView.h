#import <Cocoa/Cocoa.h>

@class CBColor;
@class ColorInputView;

NS_ASSUME_NONNULL_BEGIN

@protocol ColorInputViewDelegate <NSObject>

- (void)colorInputViewDidChange:(ColorInputView *)inputView;

- (void)colorInputViewColorWellDidChange:(ColorInputView *)inputView;

@end


@interface ColorInputView : NSView <NSTextFieldDelegate>

@property (nonatomic, strong, nullable) CBColor *color;

@property (nonatomic, readonly) NSTextField *textField;
@property (nonatomic, readonly) NSColorWell *colorWell;

@property (nonatomic, weak, nullable)
    id<ColorInputViewDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title;

- (void)showValidationError:(NSString *)message;
- (void)clearValidationError;

@end

NS_ASSUME_NONNULL_END