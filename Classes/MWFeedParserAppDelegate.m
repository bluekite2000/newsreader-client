#import "MWFeedParserAppDelegate.h"
#import "RootViewController.h"
#import "FlurryAPI.h"



@implementation MWFeedParserAppDelegate

@synthesize window;
@synthesize navigationController;
#pragma mark -
#pragma mark Application lifecycle


void uncaughtExceptionHandler(NSException *exception) {
    [FlurryAPI logError:@"Uncaught" message:@"Crash!" exception:exception];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {   
	NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    [FlurryAPI startSession:@"HVDE61X56UUBBNJTT3TV"];

	
	    // Override point for customization after app launch    
	[window addSubview:[navigationController view]];
	navigationController.delegate = self;
    [window makeKeyAndVisible];
	return YES;
}

- (void)navigationController:(UINavigationController *)navController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	
	//NSLog(@"willshow");
	if ([viewController respondsToSelector:@selector(willAppearIn:)])
		[viewController performSelector:@selector(willAppearIn:) withObject:navController];
}
 

- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

