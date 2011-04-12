#import <UIKit/UIKit.h>

@interface MWFeedParserAppDelegate : NSObject <UIApplicationDelegate, UINavigationControllerDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

