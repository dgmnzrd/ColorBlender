#import <Cocoa/Cocoa.h>

@class MainViewController;

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (strong, nonatomic) NSWindow *window;
@property (strong, nonatomic) MainViewController *mainViewController;

@end

NS_ASSUME_NONNULL_END